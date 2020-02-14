#!/bin/bash

ENV_DIR=~/.env
CODE_DIR=~/code
ANSIBLE_ENV=$ENV_DIR/ansible

# Install package requirements
requirements=(python3-venv python3-apt git)
for requirement in "${requirements[@]}"; do
    if ! apt list --installed 2>/dev/null | grep -q $requirement; then
        sudo apt-get install -y $requirement
    else
        echo "$requirement already installed"
    fi
done

# Create directories
mkdir -p $ENV_DIR
mkdir -p $CODE_DIR
cd $CODE_DIR
if [ ! -d ansible-workstation ]; then
    git clone https://github.com/enthalpychange/ansible-workstation.git
    cd ansible-workstation
else
    cd ansible-workstation
    git pull https://github.com/enthalpychange/ansible-workstation.git
fi

# Activate environment and install Python packages
if [ ! -e $ANSIBLE_ENV ]; then
    python3 -m venv --system-site-packages $ANSIBLE_ENV
fi

if [[ $VIRTUAL_ENV != $ANSIBLE_ENV ]]; then
    echo "Activating environment"
    source $ANSIBLE_ENV/bin/activate
fi

# Temp file to work around pip list broken pipe error
TEMP_FILE=$(mktemp)
if [[ $VIRTUAL_ENV == $ANSIBLE_ENV ]]; then
    packages=(wheel ansible)
    for package in "${packages[@]}"; do
        pip list --format=columns > $TEMP_FILE
        if ! grep -q "$package " $TEMP_FILE; then
            echo "Installing $package"
            pip install $package
        else
            echo "$package already installed"
        fi
    done
fi

export ANSIBLE_INVENTORY=$PWD/hosts
echo [localhost] > $ANSIBLE_INVENTORY
echo 127.0.0.1 ansible_connection=local ansible_python_interpreter=$ANSIBLE_ENV/bin/python > $ANSIBLE_INVENTORY
echo "Run this command to provision: ansible-playbook -K main.yml"
