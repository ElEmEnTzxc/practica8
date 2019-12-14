#!/bin/bash
#Este script lo ejecutaremos en la maquina que actuara como apache-server para ello instalaremos el apache y sus paquetes ademas de clonar la practica y configurar el acceso a la$
#Actualizamos los repositorios
apt-get update

#instalamos apache
apt-get install apache2 -y

#Instalamos paquetes para apache
apt-get install php libapache2-mod-php php-mysql -y

#Activacion de modulos de apache
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_ajp
sudo a2enmod rewrite
sudo a2enmod deflate
sudo a2enmod headers
sudo a2enmod proxy_balancer
sudo a2enmod proxy_connect
sudo a2enmod proxy_html
sudo a2enmod lbmethod_byrequests

#Configuracion del balanceador
#Editamos el archivo 000-default.conf que está en el directorio /etc/apache2/sites-enabled
cd /home/ubuntu
rm -r practica8/
sudo git clone https://github.com/ElEmEnTzxc/practica8.git
cd /home/ubuntu/practica8
sudo cp 000-default.conf /etc/apache2/sites-enabled/


#Reiniciamos el servidor apache
sudo /etc/init.d/apache2 restart
