#!/bin/bash

# Growing the /home volume for terraform purpose
growpart /dev/nvme0n1 4
lvextend -L +25G /dev/mapper/RootVG-homeVol
xfs_growfs /home


#Install Terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

#Clone Repositry
mkdir -p /home/ec2-user/git-repos
cd /home/ec2-user/git-repos
git clone https://github.com/rahul-paladugu/roboshop-infrastructure-terraform-modules
chown -R ec2-user:ec2-user /home/ec2-user/git-repos