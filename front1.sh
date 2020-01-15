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

# Descargamos Wordpress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz

# Descomprimimos el archivo recién descargado
tar -zxvf latest.tar.gz

# Modificamos el archivo wp-config-example.php
mv /var/www/html/wordpress/* /var/www/html
mv wp-config-sample.php wp-config.php
sed -i 's/database_name_here/wordpress/' wp-config.php
sed -i 's/username_here/wordpress/' wp-config.php
sed -i 's/password_here/wordpress/' wp-config.php
sed -i 's/localhost/184.73.143.208/' wp-config.php

# Concedemos permisos a Wordpress
chown www-data:www-data * -R

# Instalamos el servidor NFS
sudo apt-get install nfs-kernel-server -y

# Cambiamos los permisos al directorio que vamos a compartir
sudo chown nobody:nogroup /var/www/html/

# Editamos el archivo /etc/exports
cd /etc/
echo "/var/www/html/      34.227.143.77(rw,sync,no_root_squash,no_subtree_check)" > /etc/exports


# Reiniciamos el servicio nfs-kernel-server
sudo /etc/init.d/nfs-kernel-server restart

# Dirección del sitio y direccion URL
cd /var/www/html/
echo "define( 'WP_SITEURL', 'http://3.83.206.162' );" >> wp-config.php
echo "define( 'WP_HOME', 'http://3.83.206.162' );" >> wp-config.php

# Configuración de WordPress en un directorio que no es el raíz
#sudo cp /var/www/html/index.php /var/www/html/index.php
#cd /var/www/html/
#sed -i 's#wp-blog-header.php#wordpress/wp-blog-header.php#' index.php

# Creamos un archivo .htaccess

#Creamos uploads
mkdir /var/www/html/wp-content/uploads -p

# Security Keys
cd /var/www/html
rm -r index.html
#Borramos las keys
sed -i '/AUTH_KEY/d' wp-config.php
sed -i '/LOGGED_IN_KEY/d' wp-config.php
sed -i '/NONCE_KEY/d' wp-config.php
sed -i '/AUTH_SALT/d' wp-config.php
sed -i '/SECURE_AUTH_SALT/d' wp-config.php
sed -i '/LOGGED_IN_SALT/d' wp-config.php
sed -i '/NONCE_SALT/d' wp-config.php

#Añadimos las keys
CLAVES=$(curl https://api.wordpress.org/secret-key/1.1/salt/)
CLAVES=$(echo $CLAVES | tr / _)
sed -i "/#@-/a $CLAVES" /var/www/html/wp-config.php











