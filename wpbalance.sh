#!/bin/bash
# Actualizamos los repositorios
apt-get update

# Instalamos apache2
apt-get install apache2 -y

# Instalamos paquetes para apache
apt-get install php libapache2-mod-php php-mysql -y

# Activamos modulos del apache2
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp
a2enmod rewrite
a2enmod deflate
a2enmod headers
a2enmod proxy_balancer
a2enmod proxy_connect
a2enmod proxy_html
a2enmod lbmethod_byrequests

# Copiamos el archivo 000-default.conf  en el directorio /etc/apache2/sites-enabled
cd ~
git clone https://github.com/ElEmEnTzxc/practica8
cp practica8/000-default.conf /etc/apache2/sites-enabled/

# Reiniciamos Apache
sudo /etc/init.d/apache2 restart

