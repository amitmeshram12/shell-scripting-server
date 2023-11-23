#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Install Memcached and libmemcached-tools
sudo apt-get install -y memcached libmemcached-tools

# Start Memcached service
sudo systemctl start memcached

# Enable Memcached to start on boot
sudo systemctl enable memcached

# Allow Memcached to be accessible from remote hosts (if needed)
# Replace 0.0.0.0 with your specific IP address or network range
# Be cautious when allowing remote access for security reasons
sudo sed -i 's/-l 127.0.0.1/-l 0.0.0.0/' /etc/memcached.conf

# Restart Memcached to apply changes
sudo systemctl restart memcached

# add firewall rolles
sudo ufw allow 11211/tcp
sudo ufw allow 11111/udp
memcached -p 11211 -U 11111 -u memcached -d
# Print Memcached status
sudo systemctl status memcached

echo "Memcached installation and configuration completed."