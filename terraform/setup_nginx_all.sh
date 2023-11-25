#!/bin/bash

# Update and install necessary packages
sudo apt update -y
sudo apt install nginx wget unzip -y
sudo apt install mysql-server -y
sudo apt install php-fpm php-zip php-json php-mbstring php-mysql -y

# Enable and start services
sudo systemctl enable mysql
sudo systemctl start mysql
sudo systemctl enable php8.1-fpm  # Adjust version as needed
sudo systemctl start php8.1-fpm   # Adjust version as needed
sudo systemctl enable nginx
sudo systemctl start nginx

# Install Node.js and PM2
sudo apt install -y nodejs npm
sudo npm install -g pm2

# Download and setup phpMyAdmin
sudo wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip
sudo unzip phpMyAdmin-5.2.1-all-languages.zip
sudo mv phpMyAdmin-5.2.1-all-languages /usr/share/phpmyadmin
sudo ln -s  /usr/share/phpmyadmin /var/www/html/phpmyadmin
sudo chmod 775 -R /usr/share/phpmyadmin/
sudo chown root:www-data -R /usr/share/phpmyadmin/


# Create a random password for phpMyAdmin
PHPMYADMIN_PASSWORD="961815114136Ab@"

# Create a new database user for phpMyAdmin
sudo mysql -e "CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY '$PHPMYADMIN_PASSWORD';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"

# Configure Nginx for phpMyAdmin
sudo chmod -R 777 /etc/nginx/sites-available/
sudo tee /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;
    index index.php index.html index.htm;
	server_name _;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }

}
EOF

# Test Nginx configuration
sudo apt update -y
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx

echo "phpMyAdmin setup completed."
echo "Username: phpmyadmin"
echo "Password: $PHPMYADMIN_PASSWORD"
