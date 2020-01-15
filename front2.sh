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

cd /var/www/html
rm -r index.html

# Configuración de php-fpm
cd /etc/php/7.2/fpm/
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' php.ini

# Instalamos el cliente NFS
sudo apt-get install nfs-common -y

# Creamos el punto de montaje en el cliente NFS
sudo mount 54.152.80.179:/var/www/html/ /var/www/html/

# Editamos el archivo /etc/fstab
cd /etc/
echo "54.152.80.179:/var/www/html/ /var/www/html/  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab
