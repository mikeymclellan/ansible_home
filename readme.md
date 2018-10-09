# Ansible Scripts for Home Network

Currently configures a [EdgeRouter-X](https://www.ubnt.com/edgemax/edgerouter-x/) as the firewall and a bunch of Raspberry Pis.

Typical usage:

```
ansible-playbook -i inventory main.yml --tags firewall -l home.mclellan.org.nz
```

## Raspberry Pis

### Flash a new SD card and setup wifi 

    wget http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-07-05/2017-07-05-raspbian-jessie-lite.zip
    unzip 2017-07-05-raspbian-jessie-lite.zip
    dd bs=4M if=2017-07-05-raspbian-jessie-lite.img of=/dev/sda conv=fsync
    mkdir /tmp/new_sd_card 
    mount /dev/sda2 /tmp/new_sd_card
    cp  /etc/network/interfaces.d/wlan0_wificlient /tmp/new_sd_card/etc/network/interfaces.d/
    cp  /etc/wpa_supplicant/wpa_supplicant.conf  /tmp/new_sd_card/etc/wpa_supplicant
    ln -s /lib/systemd/system/ssh.service /tmp/new_sd_card/etc/systemd/system/multi-user.target.wants/ssh.service 
    umount /tmp/new_sd_card
    
### To bootstrap a new machine with no ssh keys yet, add the IP to `/etc/hosts` and run:

    ansible-playbook -i inventory main.yml --ask-pass -l [hostname]
    
It'll fail after changing the `pi` users password so after that just re-run the command without `--ask-pass`

 