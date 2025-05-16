#!/bin/bash

echo "🔧 Starting full stack setup (Nginx, PHP, MySQL, Node.js, phpMyAdmin)..."

# Prompt user for MySQL root password with validation and confirmation
while true; do
    echo "🔐 Please enter a strong MySQL root password."
    echo "   - Minimum 8 characters"
    echo "   - At least one uppercase letter"
    echo "   - At least one lowercase letter"
    echo "   - At least one number"
    echo "   - At least one special character (!@#\$%^&* etc.)"
    read -sp "Enter desired MySQL root password: " MYSQL_ROOT_PASSWORD
    echo ""
    read -sp "Confirm password: " MYSQL_ROOT_PASSWORD_CONFIRM
    echo ""

    # Check for empty input
    if [[ -z "$MYSQL_ROOT_PASSWORD" ]]; then
        echo "❌ Password cannot be empty. Please try again."
        continue
    fi

    # Check strength
    if [[ ${#MYSQL_ROOT_PASSWORD} -lt 8 || ! "$MYSQL_ROOT_PASSWORD" =~ [A-Z] || ! "$MYSQL_ROOT_PASSWORD" =~ [a-z] || ! "$MYSQL_ROOT_PASSWORD" =~ [0-9] || ! "$MYSQL_ROOT_PASSWORD" =~ [\!\@\#\$\%\^\&\*\(\)\_\+\-=\[\]\{\}\;\:\'\"\\\|\,\.\<\>\?\/] ]]; then
        echo "❌ Password is too weak. Please follow the suggested rules."
        continue
    fi

    # Check confirmation
    if [[ "$MYSQL_ROOT_PASSWORD" != "$MYSQL_ROOT_PASSWORD_CONFIRM" ]]; then
        echo "❌ Passwords do not match. Please try again."
        continue
    fi

    # Passed all checks
    break
done
echo "✅ Password confirmed."

# Update and install basic tools
sudo apt update -y
sudo apt install -y nginx wget unzip curl software-properties-common

# 🔥 Remove Apache if installed
echo "🔄 Removing Apache if it's installed..."
sudo systemctl stop apache2 2>/dev/null || true
sudo systemctl disable apache2 2>/dev/null || true
sudo apt purge -y apache2 apache2-utils apache2-bin apache2.2-common 2>/dev/null || true
sudo apt autoremove -y

# Install PHP and extensions
sudo apt install -y php php-fpm php-zip php-json php-mbstring php-mysql

# Get PHP version dynamically (e.g., 8.1)
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

# Preconfigure MySQL root password for non-interactive installation
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

# Install MySQL Server
sudo apt install -y mysql-server

# Secure MySQL installation
sudo mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="DELETE FROM mysql.user WHERE User='';"
sudo mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="DROP DATABASE IF EXISTS test;"
sudo mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="FLUSH PRIVILEGES;"

# Enable and start services
sudo systemctl enable mysql
sudo systemctl start mysql
sudo systemctl enable php${PHP_VERSION}-fpm
sudo systemctl start php${PHP_VERSION}-fpm
sudo systemctl enable nginx
sudo systemctl start nginx

# Install Node.js and PM2
sudo apt install -y nodejs npm
sudo npm install -g pm2

# Download and set up phpMyAdmin
sudo wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip
sudo unzip phpMyAdmin-5.2.1-all-languages.zip
sudo mv phpMyAdmin-5.2.1-all-languages /usr/share/phpmyadmin
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
sudo chmod 775 -R /usr/share/phpmyadmin/
sudo chown root:www-data -R /usr/share/phpmyadmin/

# Configure Nginx to serve phpMyAdmin and PHP
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
	index index.php index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ /index.html?q=\$uri&\$args;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php${PHP_VERSION}-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Test and reload Nginx
sudo nginx -t && sudo systemctl reload nginx

# Cleanup
rm -f phpMyAdmin-5.2.1-all-languages.zip

# Success message
echo ""
echo "✅ Full stack setup completed successfully!"
echo "🌐 Visit web: http://your-ec2-public-ip"
echo "🌐 Visit phpmyadmin: http://your-ec2-public-ip/phpmyadmin"
echo "👤 MySQL User: root"
echo "🔐 MySQL Password: $MYSQL_ROOT_PASSWORD"
