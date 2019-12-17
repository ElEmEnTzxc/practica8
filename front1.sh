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

#Instalamos git
apt-get install git -y

# Instalación de php-fpm y php-mysql
apt-get install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
apt-get install php-fpm php-mysql -y


# Descargamos Wordpress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz

# Descomprimimos el archivo recién descargado
tar -zxvf latest.tar.gz 
cp /var/www/html/wordpress/* /var/www/html/
rm -r wordpress

# Modificamos el archivo wp-config-example.php

mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

sed -i 's/database_name_here/wordpress' /var/www/html/wp-config.php
sed -i 's/username_here/wordpress' /var/www/html/wp-config.php
sed -i 's/password_here/wordpress' /var/www/html/wp-config.php
sed -i 's/localhost/3.94.203.50/' /var/www/html/wp-config.php

# Concedemos permisos a Wordpress
chown www-data:www-data * -R

# Instalamos el servidor NFS
apt-get install nfs-kernel-server -y



# Dirección del sitio y direccion URL 
cd /var/www/html/
echo "define( 'WP_SITEURL', 'http://34.205.25.119' );" >> wp-config.php
echo "define( 'WP_HOME', 'http://34.205.25.119' );" >> wp-config.php




#Creamos uploads
mkdir /var/www/html/wp-content/uploads -p

# Security Keys
#Borramos las keys
sed -i '/AUTH_KEY/d' /var/www/html/wp-config.php
sed -i '/LOGGED_IN_KEY/d' /var/www/html/wp-config.php
sed -i '/NONCE_KEY/d' /var/www/html/wp-config.php
sed -i '/AUTH_SALT/d' /var/www/html/wp-config.php
sed -i '/SECURE_AUTH_SALT/d' /var/www/html/wp-config.php
sed -i '/LOGGED_IN_SALT/d' /var/www/html/wp-config.php
sed -i '/NONCE_SALT/d' /var/www/html/wp-config.php

#Añadimos las nuevas keys
CLAVES=$(curl https://api.wordpress.org/secret-key/1.1/salt/)
CLAVES=$(echo $CLAVES | tr / _)
sed -i "/#@-/a $CLAVES" /var/www/html/wp-config.php


#Borramos el index.html para que se nos rediriga al index.php
cd /var/www/html
rm -r index.html

# Cambiamos los permisos al directorio que vamos a compartir
chown nobody:nogroup /var/www/html/

# Editamos el archivo /etc/exports
cd /etc/
echo "/var/www/html/      34.228.185.147(rw,sync,no_root_squash,no_subtree_check)" > /etc/exports


# Reiniciamos el servicio nfs-kernel-server
sudo /etc/init.d/nfs-kernel-server restart


