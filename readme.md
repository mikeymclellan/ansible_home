# Ansible Scripts

Files in `host_vars` and `group_vars` wont be commited so you can safely put sensitive data in there like private keys.

## Cheat sheet

To run a spcific playbook on one machine:

    ansible-playbook -i inventory raspberry_pi.yml -l brew-fridge

To bootstrap a new machine with no ssh keys yet, add the IP to `/etc/hosts` and run:

    ansible-playbook -i inventory main.yml --ask-pass -l [hostname]
    
It'll fail after changing the `pi` users password so after that just re-run the command without `--ask-pass`

