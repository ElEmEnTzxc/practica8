#!/bin/bash
#Instalamos git
apt-get update
apt-get install git -y

#instalamos las debconf-utils
apt-get install debconf-utils -y

#Configuramos la contraseña del root para Mysql
DB_ROOT_PASSWD=root
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"

#Instalamos MYSQL Server
apt-get install mysql-server -y

#Configuramos la red
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

#Configuramos la base de datos de la aplicación web
DB_NAME=wordpress
DB_USER=wordpress
DB_PASSWD=wordpress
mysql -u root -p$DB_ROOT_PASSWD <<< "DROP DATABASE IF EXISTS $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<< "CREATE DATABASE $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%' IDENTIFIED BY '$DB_PASSWD';"
mysql -u root -p$DB_ROOT_PASSWD <<< "FLUSH PRIVILEGES"


#Reiniciamos el servicio mysql
systemctl restart mysql

cd /home/ubuntu
rm -rf iaw-practica-lamp
git clone  https://github.com/josejuansanchez/iaw-practica-lamp.git
mysql -u root -p$DB_ROOT_PASSWD < /home/ubuntu/iaw-practica-lamp/db/database.sql


