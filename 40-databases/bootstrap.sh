#!/bin/bash
component=$1
environment=$2
sudo dnf install ansible -y
#Ansible-pull is not working as expected. Hence we go with regular ansible way.
#ansible-pull -U https://github.com/rahul-paladugu/roboshop-configuration-ansible-for-terrafrom.git -e component=$component main.yaml
# Ensure correct ownership (fix root/ec2 mismatch)
sudo mkdir -p /opt/roboshop/ansible
sudo chown -R ec2-user:ec2-user /opt/roboshop

repo_url="https://github.com/rahul-paladugu/roboshop-configuration-ansible-for-terrafrom.git"
base_dir="/opt/roboshop/ansible"
repo_dir="$base_dir/roboshop-configuration-ansible-for-terrafrom"

cd "$base_dir" || exit

# IMPORTANT: always fix broken repo state
if [ -d "$repo_dir/.git" ]; then
  echo "Updating repo..." >> /tmp/ansible.log
  cd "$repo_dir" || exit
  git pull >> /tmp/ansible.log 2>&1

else
  echo "Fresh clone..." >> /tmp/ansible.log

  # force clean broken state
  sudo rm -rf "$repo_dir"

  # explicit clone destination (CRITICAL FIX)
  git clone "$repo_url" "$repo_dir" >> /tmp/ansible.log 2>&1

  cd "$repo_dir" || exit
fi

# FETCH SECRET 
MYSQL_ROOT_PASSWORD=$(aws ssm get-parameter \
  --name "/roboshop/db/${environment}/mysql_root_password" \
  --with-decryption \
  --query Parameter.Value \
  --output text)
  
export MYSQL_ROOT_PASSWORD

# verify playbook exists before running
ls -l main.yaml || {
  echo "main.yaml NOT FOUND - wrong repo structure" >> /tmp/ansible.log
  exit 1
}

ansible-playbook -e component="$component" -e environment="$environment"  mysql_root_password="$MYSQL_ROOT_PASSWORD" main.yaml

