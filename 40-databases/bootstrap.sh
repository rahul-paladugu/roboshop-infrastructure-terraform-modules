#!/bin/bash

dny install ansible -y
ansible-pull -u https://github.com/rahul-paladugu/roboshop-ansible-collection.git -e component=mongodb main.yaml