# Ansible Scripts

Files in `host_vars` and `group_vars` wont be commited so you can safely put sensitive data in there like private keys.

## Cheat sheet

    ansible-playbook -i inventory raspberry_pi.yml -l brew-fridge
