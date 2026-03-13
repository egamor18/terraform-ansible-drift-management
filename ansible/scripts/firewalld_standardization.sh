#!/bin/bash

# 1. Install firewalld
dnf install -y firewalld

# 2. Start and enable the service
systemctl enable --now firewalld

# 3. Open Ports
# Port 22 (SSH) is usually open by default, but we'll be explicit
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https

# Alternatively, using port numbers:
# firewall-cmd --permanent --add-port=22/tcp
# firewall-cmd --permanent --add-port=80/tcp
# firewall-cmd --permanent --add-port=443/tcp

# 4. Reload to apply changes
firewall-cmd --reload