#!/bin/bash
# Update the system
sudo apt update -y

# Install and configure Nginx
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Install and start MySQL
# sudo amazon-linux-extras install -y mysql8
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Install PHPMyAdmin
# sudo amazon-linux-extras install -y epel
sudo apt install -y phpMyAdmin

# Install Node.js and PM2
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node
npm install -g pm2

# Start services
sudo systemctl restart nginx

echo "All configurations are working !" > /var/www/html/index.html