#!/bin/bash
component=$1
sudo dnf install ansible -y
#Ansible-pull is not working as expected. Hence we go with regular ansible way.
#ansible-pull -U https://github.com/rahul-paladugu/roboshop-configuration-ansible-for-terrafrom.git -e component=$component main.yaml
# Git repository URL containing Ansible configuration
repo_url="https://github.com/rahul-paladugu/roboshop-configuration-ansible-for-terrafrom.git"

# Base directory where all Ansible-related files will be stored
base_dir="/opt/roboshop/ansible"

# Full path where the Git repo will be cloned
repo_dir="$base_dir/roboshop-configuration-ansible-for-terrafrom"

# Ensure base directory exists (creates parent directories if needed)
sudo mkdir -p "$base_dir"

# Move into base directory; exit script if this fails
cd "$base_dir" || exit

# Check if the repo is already cloned (presence of .git folder)
if [ -d "$repo_dir/.git" ]; then
  # If repo exists, update it with latest changes from remote
  cd "$repo_dir"
  git pull >> /tmp/ansible.log 2>&1   # log output for debugging
else
  # If repo does not exist, clone it from GitHub
  git clone "$repo_url" >> /tmp/ansible.log 2>&1

  # Move into the newly cloned repository
  cd "$repo_dir"
fi

# Debug step: verify that the main Ansible playbook exists
ls -l main.yaml

# Run Ansible playbook and pass the component variable dynamically
ansible-playbook -e component="$component" main.yaml