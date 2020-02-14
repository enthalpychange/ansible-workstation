# Ansible-Workstation

## Setup
Run the bootstrap script to install requirements.

- Using wget: `source <(wget -O - https://raw.githubusercontent.com/enthalpychange/ansible-workstation/master/bootstrap)`
- Using curl: `source <(curl -L https://raw.githubusercontent.com/enthalpychange/ansible-workstation/master/bootstrap)`

## Provision
Run the playbook: `ansible-playbook -K main.yml`
