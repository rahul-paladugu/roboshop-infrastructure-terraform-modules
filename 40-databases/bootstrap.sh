#!/bin/bash
component=$1
dnf install ansible -y
ansible-pull -U https://github.com/rahul-paladugu/roboshop-ansible-collection.git -e component=$component main.yaml