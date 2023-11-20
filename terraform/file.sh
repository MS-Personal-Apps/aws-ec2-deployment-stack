#!/bin/bash

# Update and install necessary packages
sudo apt update -y
sudo apt install apache2 wget unzip -y
sudo apt install mysql-server -y
sudo apt install php php-zip php-json php-mbstring php-mysql -y

# Enable and start services
sudo systemctl enable mysql
sudo systemctl start mysql
sudo systemctl enable apache2
sudo systemctl start apache2

# Install Node.js and PM2
sudo apt install -y nodejs npm
sudo npm install -g pm2

# Download and setup phpMyAdmin
sudo wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip
sudo unzip phpMyAdmin-5.2.1-all-languages.zip
sudo mv phpMyAdmin-5.2.1-all-languages /usr/share/phpmyadmin
sudo mkdir /usr/share/phpmyadmin/tmp
sudo chown -R www-data:www-data /usr/share/phpmyadmin
sudo chmod 777 /usr/share/phpmyadmin/tmp

# Configure Apache for phpMyAdmin
sudo cat << EOF >> /etc/apache2/conf-available/phpmyadmin.conf
Alias /phpmyadmin /usr/share/phpmyadmin
Alias /phpMyAdmin /usr/share/phpmyadmin
 
<Directory /usr/share/phpmyadmin/>
   AddDefaultCharset UTF-8
   <IfModule mod_authz_core.c>
      <RequireAny>
      Require all granted
     </RequireAny>
   </IfModule>
</Directory>
 
<Directory /usr/share/phpmyadmin/setup/>
   <IfModule mod_authz_core.c>
     <RequireAny>
       Require all granted
     </RequireAny>
   </IfModule>
</Directory>
EOF

# Enable phpMyAdmin configuration
sudo a2enconf phpmyadmin
sudo systemctl restart apache2
