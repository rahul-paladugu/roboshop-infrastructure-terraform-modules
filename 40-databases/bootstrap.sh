#!/bin/bash
component=$1
sudo dnf install ansible -y
ansible-pull -U https://github.com/rahul-paladugu/roboshop-configuration-ansible-for-terrafrom.git -e component=$component main.yaml