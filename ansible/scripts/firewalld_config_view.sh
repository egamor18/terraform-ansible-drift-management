#!/bin/bash

# --- Data Retrieval ---
# Using $(...) captures the text output of the command into the variable
state=$(systemctl is-active firewalld)
enabled=$(systemctl is-enabled firewalld)
ports=$(sudo firewall-cmd --list-ports)

# --- Display Output ---
echo "--------------------------------------------"
echo " firewalld Status Report"
echo "--------------------------------------------"

echo "firewalld active?: ${state}"
echo "enabled at boot?:  ${enabled}"
#echo "open ports:        ${ports:-none}" # Displays 'none' if the variable is empty

# list all active ports, services, etc
sudo firewall-cmd --list-all

echo "--------------------------------------------"