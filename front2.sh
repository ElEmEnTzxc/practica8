#!/bin/bash
set -x

#Actualizamos los repositorios
apt-get update

#Instalamos apache
apt-get install apache2 -y

#Instalamos paquetes para apache
apt-get install php libapache2-mod-php php-mysql -y

#Instalamos adminer
cd /var/www/html
mkdir adminer
cd adminer
wget https://github.com/vrana/adminer/releases/download/v4.3.1/adminer-4.3.1-mysql.php
mv adminer-4.3.1-mysql.php index.php

#Instalamos git
apt-get install git -y

# Instalación de php-fpm y php-mysql
apt-get install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
apt-get install php-fpm php-mysql -y

# Configuración de php-fpm
cd /etc/php/7.2/fpm/
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' php.ini


# Modificamos el archivo wp-config-example.php
cd /var/www/html/wordpress
mv wp-config-sample.php wp-config.php
sed -i 's/database_name_here/wordpress/' wp-config.php
sed -i 's/username_here/wordpress/' wp-config.php
sed -i 's/password_here/wordpress/' wp-config.php
sed -i 's/localhost/3.83.15.117/' wp-config.php

# Concedemos permisos a Wordpress
chown www-data:www-data * -R

# Instalamos el cliente NFS
sudo apt-get install nfs-common -y

# Creamos el punto de montaje en el cliente NFS
sudo mount 3.91.199.203:/var/www/html/wordpress/wp-content /var/www/html/wordpress/wp-content









