#!/bin/bash
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

# Instalación de php-fpm y php-mysql
apt-get install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
apt-get install php-fpm php-mysql -y



# Instalamos el cliente NFS
apt-get install nfs-common -y

# Creamos el punto de montaje en el cliente NFS
mount 34.224.79.119:/var/www/html /var/www/html


