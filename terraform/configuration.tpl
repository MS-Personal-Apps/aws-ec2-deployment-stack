#!/bin/bash
# Update the system
sudo apt update -y
sudo apt upgrade -y

# Install and configure Nginx
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Install and start MySQL
sudo apt install -y mysql-server mysql-client
sudo systemctl start mysql
sudo systemctl enable mysql

# Install PHPMyAdmin
sudo apt install -y phpmyadmin
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# Install Node.js and PM2
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Reload environment variables
source "$HOME/.bashrc"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node

# Install PM2
npm install pm2 -g

# Start services
sudo systemctl restart nginx

echo "All configurations are working !" | sudo tee /var/www/html/index.html
