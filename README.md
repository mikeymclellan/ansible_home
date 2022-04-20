# Ansible Scripts for Home Network

Configures a NAS server running Samba for network backups, a Snapserver for multi-room music streaming, and an OpenVPN 
client which we route traffic for streaming video from the UK. 

As part of the `openvpn_router` role, it will also create the OpenVPN server as part of an AWS Cloudformation stack in 
AWS' London region.

It also has a role for taking a backup of the [EdgeRouter-X](https://www.ubnt.com/edgemax/edgerouter-x/) config.

Additionally, it has some deprecated roles included for:

 * KerberosIO video surveillance 
 * Airplay server
 * Kodi TV 
 
# Prerequisites

If setting up a Unifi controller: 

    ansible-galaxy install lifeofguenter.unifi-controller

Typical usage:

    ansible-playbook -i inventory main.yml -l nas
    ansible-playbook -i inventory main.yml -l nas -t openvpn_routers

Taking a backup of the firewall config:

    ansible-playbook -i inventory main.yml -l firewalls

## NAS

The NAS server is running Avahi (Bonjour) so it should just appear in Apple Finder, but otherwise you can connect with 

    open smb://mikey@nas

## Video Streaming VPN 

To allow access to video streaming service in the UK we set up an OpenVPN client on the NAS server and an AWS stack 
running the OpenVPN server in the AWS London region. The NAS server's default route sends everything thru the VPN and 
it's setup to forward & NAT traffic.

The Edgerouter (firewall) is set up with a dynamic firewall group called `RouteThruUkVpn` which is populated 
automatically by dnsmasq whenever a DNS address is resolved matching the `ipset` parameter in config. 

The Edgerouter also has a RouteThruUkVpn modify rule added to the firewall which will use route table 2 for anything in 
the `RouteThruUkVpn` group. Route table 2 simply forwards all traffic to 192.168.1.68 (NAS).

The other way this could be achieved is by running the OpenVPN client directly on the Edgerouter, however the 
performance isn't very good.  

## Bootstrapping Raspberry Pis

You can download & flash Raspian with:

    wget --content-disposition https://downloads.raspberrypi.org/raspbian_lite_latest && \
    DOWNLOAD=`ls -tr | tail -1` ; \
    unzip $DOWNLOAD && \
    ARCHIVE=`ls -tr | tail -1` ; \
    dd bs=4M if=$ARCHIVE of=/dev/sda conv=fsync

Add the Wifi config directly to the SD card before booting it:

```
mkdir /tmp/new_sd_card
mount /dev/sda2 /tmp/new_sd_card
cat > /tmp/new_sd_card/etc/network/interfaces.d/wlan0_wificlient <<EOF
auto wlan0
allow-hotplug wlan0
iface wlan0 inet manual
  wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
EOF

cat > /tmp/new_sd_card/etc/wpa_supplicant/wpa_supplicant.conf <<EOF
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

country=NZ

network={
    ssid="McLellan"
    psk="blahblah"
}
EOF

ln -s /lib/systemd/system/ssh.service /tmp/new_sd_card/etc/systemd/system/multi-user.target.wants/ssh.service 
```

To provision a new Pi which is on the network with only the default `pi` account:

    ansible-playbook -i inventory main.yml -e 'ansible_ssh_user=pi ansible_ssh_pass=raspberry' -l nas
