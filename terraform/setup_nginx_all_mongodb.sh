#!/bin/bash

# Update and install necessary packages
sudo apt update -y
sudo apt install nginx wget unzip -y

# Enable and start services
sudo systemctl enable nginx
sudo systemctl start nginx

# Install Node.js and PM2
sudo apt install -y nodejs npm
sudo npm install -g pm2

# Make directories
sudo mkdir /var/www/html/development
sudo mkdir /var/www/html/staging
sudo mkdir /var/www/html/production

# Configure Nginx
sudo chmod -R 777 /etc/nginx/sites-available/
sudo tee /etc/nginx/sites-available/default <<EOF
##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# https://www.nginx.com/resources/wiki/start/
# https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/
# https://wiki.debian.org/Nginx/DirectoryStructure
#
# In most cases, administrators will remove this file from sites-enabled/ and
# leave it as reference inside of sites-available where it will continue to be
# updated by the nginx packaging team.
#
# This file will automatically load configuration files provided by other
# applications, such as Drupal or Wordpress. These applications will be made
# available underneath a path with that package name, such as /drupal8.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

# Default server configuration
#
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;

	# Add index.html to the list
	index index.html index.nginx-debian.html;

	server_name _;

	location / {
        try_files \$uri \$uri/ /index.html?q=\$uri&\$args;
	}

	location /development {
        alias /var/www/html/development;
        index index.html;
        try_files \$uri \$uri/ /development/index.html;
    }

    location /staging {
        alias /var/www/html/staging;
        index index.html;
        try_files \$uri \$uri/ /staging/index.html;
    }

    location /production {
        alias /var/www/html/production;
        index index.html;
        try_files \$uri \$uri/ /production/index.html;
    }

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
	#	deny all;
	#}
}
EOF

# Install Docker
sudo apt-get update -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add the current user to the docker group to run docker commands without sudo
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Restart docker
sudo systemctl restart docker

# Install MongoDB
sudo apt install -y mongodb

# Start and enable MongoDB
sudo systemctl start mongodb
sudo systemctl enable mongodb

# Test Nginx configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx

echo "MongoDB and Nginx setup completed."

# Restart the shell to apply group changes
exec su -l $USER
