#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Install prerequisites
sudo apt-get install -y curl gnupg

# Add the RabbitMQ signing key
curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/rabbitmq-archive-keyring.gpg

# Add RabbitMQ APT repository
echo "deb [signed-by=/usr/share/keyrings/rabbitmq-archive-keyring.gpg] https://dl.bintray.com/rabbitmq-erlang/debian focal erlang" | sudo tee /etc/apt/sources.list.d/bintray.erlang.list > /dev/null
echo "deb [signed-by=/usr/share/keyrings/rabbitmq-archive-keyring.gpg] https://dl.bintray.com/rabbitmq/debian focal main" | sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list > /dev/null

# Install RabbitMQ
sudo apt-get update
sudo apt-get install -y rabbitmq-server

# Enable RabbitMQ Management Plugin
sudo rabbitmq-plugins enable rabbitmq_management

# Start RabbitMQ server
sudo systemctl start rabbitmq-server

# Enable RabbitMQ server to start on boot
sudo systemctl enable rabbitmq-server

# Allow RabbitMQ management interface (assuming you want to access it remotely)
sudo ufw allow 5672

# Print RabbitMQ status
sudo rabbitmqctl status

echo "RabbitMQ installation and configuration completed."

sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo systemctl restart rabbitmq-server