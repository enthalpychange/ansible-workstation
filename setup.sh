#!/bin/bash

ANSIBLE_ENV=~/.env/ansible
mkdir -p ~/.env

requirements=(python3-venv python3-apt)
for requirement in "${array[@]}"; do
    if ! apt list --installed 2>/dev/null | grep -q $requirement; then
        sudo apt-get install -y $requirement
    fi
done


if [ ! -e $ANSIBLE_ENV ]; then
    python3 -m venv --system-site-packages $ANSIBLE_ENV
fi

if [[ $VIRTUAL_ENV != $ANSIBLE_ENV ]]; then
    echo "Activating environment"
    source $ANSIBLE_ENV/bin/activate
fi

if [[ $VIRTUAL_ENV == $ANSIBLE_ENV ]]; then
    if ! pip freeze | grep -q ansible==; then
        echo "Installing ansible"
        pip install ansible
    fi
    export ANSIBLE_INVENTORY=$PWD/hosts
    echo [localhost] > $ANSIBLE_INVENTORY
    echo 127.0.0.1 ansible_connection=local ansible_python_interpreter=$ANSIBLE_ENV/bin/python > $ANSIBLE_INVENTORY
fi

