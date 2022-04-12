# Ansible Scripts for Home Network

Currently, the only host this configures is a NAS server running Samba for network backups and Snapserver for multi-room
music streaming. 

It also has a role for taking a backup of the [EdgeRouter-X](https://www.ubnt.com/edgemax/edgerouter-x/) config.

It has roles included for:

 * KerberosIO video surveillance 
 * Airplay server
 * Kodi TV 
 
# Prerequisites

If setting up a Unifi controller: 

    ansible-galaxy install lifeofguenter.unifi-controller

Typical usage:

    ansible-playbook -i inventory main.yml -l nas


Taking a backup of the firewall config:

    ansible-playbook -i inventory main.yml -l firewalls

## NAS

The NAS server is running Avahi (Bonjour) so it should just appear in Apple Finder, but otherwise you can connect with 

    open smb://mikey@nas

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
