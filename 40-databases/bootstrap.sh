#!/bin/bash
component=$1
sudo dnf install ansible -y
#Ansible-pull is not working as expected. Hence we go with regular ansible way.
#ansible-pull -U https://github.com/rahul-paladugu/roboshop-configuration-ansible-for-terrafrom.git -e component=$component main.yaml
# Git repository URL containing Ansible playbooks and roles
repo_url="https://github.com/rahul-paladugu/roboshop-configuration-ansible-for-terrafrom.git"

# Base directory where all Roboshop Ansible automation will reside
base_dir="/opt/roboshop/ansible"

# Final directory where the Git repository will be cloned
repo_dir="$base_dir/roboshop-configuration-ansible-for-terrafrom"

# Ensure base directory exists (creates parent directories if missing)
sudo mkdir -p "$base_dir"

# Move into base directory; exit script if this fails
cd "$base_dir" || exit

# Check if a valid Git repository already exists (.git folder is the source of truth)
if [ -d "$repo_dir/.git" ]; then

  # If repo exists, update it with latest changes from remote branch
  echo "Repo exists, pulling latest changes..." >> /tmp/ansible.log

  # Move into repository directory
  cd "$repo_dir" || exit

  # Pull latest changes safely and log output for debugging
  git pull >> /tmp/ansible.log 2>&1

else

  # If repo does not exist OR is broken, perform a fresh clone
  echo "Fresh clone..." >> /tmp/ansible.log

  # Remove any partially created or corrupted directory to avoid git conflicts
  rm -rf "$repo_dir"

  # Clone repository explicitly into the target directory (avoids nested folder issues)
  git clone "$repo_url" "$repo_dir" >> /tmp/ansible.log 2>&1

  # Move into the newly cloned repository
  cd "$repo_dir" || exit

fi

# Debug step: verify that the main Ansible playbook exists
ls -l main.yaml

# Run Ansible playbook and pass the component variable dynamically
ansible-playbook -e component="$component" main.yaml