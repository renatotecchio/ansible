#!/bin/bash

# Script to configure raspberry
# Usage ./raspberry.sh [ip_host]

SSH_KEY="$HOME/.ssh/id_rsa.pub"
USER="pi"
PASSWORD="raspberry"
INVENTORY_FILE="hosts.ini"

if [ -z $1 ]
  then
   echo ""
   echo "Error: Missing parameters!"
   echo "Use:"
   echo "./raspberry.sh [ip_host]"
   echo ""
   exit 1
  else
    
    sshpass -p $PASSWORD ssh-copy-id -i $SSH_KEY -o "StrictHostKeyChecking no" $USER@$1
    
#    echo "[raspberrypi]" > $INVENTORY_FILE
#    echo "$1" >> $INVENTORY_FILE
#    echo "[linuxsetup]" >> $INVENTORY_FILE
#    echo "$1" >> $INVENTORY_FILE
    
#    ansible-playbook ../playbooks/raspberry.yml -i hosts.ini -u pi --private-key /home/$USER/.ssh/id_rsa

fi
