# Ansible Scripts

Files in `host_vars` and `group_vars` wont be commited so you can safely put sensitive data in there like private keys.

## Cheat sheet

To run a spcific playbook on one machine:

    ansible-playbook -i inventory raspberry_pi.yml -l brew-fridge


Bootstrap wifi before booting the device: 

    dd bs=4M if=2017-01-11-raspbian-jessie-lite.img of=/dev/sda conv=fsync
    mkdir /tmp/new_sd_card 
    mount /dev/sda2 /tmp/new_sd_card
    cp  /etc/network/interfaces.d/wlan0_wificlient /tmp/new_sd_card/etc/network/interfaces.d/
    cp  /etc/wpa_supplicant/wpa_supplicant.conf  /tmp/new_sd_card/etc/wpa_supplicant
    umount /tmp/new_sd_card
    
    *** Missing to set ssh servvice to start on boot ***
    
    
To bootstrap a new machine with no ssh keys yet, add the IP to `/etc/hosts` and run:

    ansible-playbook -i inventory main.yml --ask-pass -l [hostname]
    
It'll fail after changing the `pi` users password so after that just re-run the command without `--ask-pass`

 