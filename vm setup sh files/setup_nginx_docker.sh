#!/bin/bash

# Update system packages
sudo apt update -y
sudo apt install nginx wget curl software-properties-common -y

# Install and configure Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Configure Nginx default site
sudo tee /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ /index.html?q=\$uri&\$args;
    }
}
EOF

# Install Docker
sudo apt-get update -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker GPG key and repository
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker packages
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Configure Docker user permissions
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Restart services
sudo systemctl restart docker
sudo nginx -t
sudo systemctl reload nginx

echo "Installation completed successfully!"

# Restart shell session
exec su -l $USER