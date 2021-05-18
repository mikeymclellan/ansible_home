# Ansible Scripts for Home Network

Currently configures a [EdgeRouter-X](https://www.ubnt.com/edgemax/edgerouter-x/) as the firewall and a bunch of Raspberry Pis.

# Prerequisites

    ansible-galaxy install michalschott.netatalk
    ansible-galaxy install lifeofguenter.unifi-controller

Typical usage:

```
ansible-playbook -i inventory main.yml --tags firewall -l home.mclellan.org.nz
```

## Raspberry Pis

To provision a new pi:
    
    ansible-playbook -i inventory main.yml -e 'ansible_ssh_user=pi ansible_ssh_pass=raspberry' -l brew-fridge 

### Flash a new SD card and setup wifi 

    wget http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-07-05/2017-07-05-raspbian-jessie-lite.zip
    unzip 2017-07-05-raspbian-jessie-lite.zip
    dd bs=4M if=2017-07-05-raspbian-jessie-lite.img of=/dev/sda conv=fsync
    mkdir /tmp/new_sd_card 
    mount /dev/sda2 /tmp/new_sd_card
    cp /etc/network/interfaces.d/wlan0_wificlient /tmp/new_sd_card/etc/network/interfaces.d/
    cp /etc/wpa_supplicant/wpa_supplicant.conf  /tmp/new_sd_card/etc/wpa_supplicant
    ln -s /lib/systemd/system/ssh.service /tmp/new_sd_card/etc/systemd/system/multi-user.target.wants/ssh.service 
    umount /tmp/new_sd_card
 
 
or if not on a Linux machine:
 
```
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

ln -s /lib/systemd/system/ssh.service /tmp/new_sd_card/etc/systemd/system/multi-user.target.wants/ssh.service 

```

