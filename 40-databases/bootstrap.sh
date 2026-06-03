#!/bin/bash
component=$1
sudo dnf install ansible -y
#Ansible-pull is not working as expected. Hence we go with regular ansible way.
#ansible-pull -U https://github.com/rahul-paladugu/roboshop-configuration-ansible-for-terrafrom.git -e component=$component main.yaml
repo_url=https://github.com/rahul-paladugu/roboshop-configuration-ansible-for-terrafrom.git
ansible_repo_directory=/opt/roboshop/ansible
ansible_directory=roboshop-configuration-ansible-for-terrafrom

sudo mkdir -p "$ansible_repo_directory"
sudo mkdir -p "/var/log/roboshop/"
log_file="/var/log/roboshop/ansible.log"

cd $ansible_repo_directory
if [ -d "$ansible_directory" ]; then
  cd "$ansible_directory"
  git pull >&$log_file
else
 sudo mkdir -p "$ansible_directory"
 cd $ansible_directory
 git clone "$repo_url" >&$log_file
fi

ansible-playbook -e component=$component main.yaml