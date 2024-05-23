#!/bin/bash
# Fichier de configuration créé dans le but d'automatiser
# la mise en place d'un serveur web Apache.

source ../config.cfg

# Configuration du serveur web
systemctl start httpd
systemctl enable httpd

# Chemin vers votre fichier httpd.conf
HTTPD_CONF="/etc/httpd/conf/httpd.conf"

# Sauvegarde 
cp $HTTPD_CONF $HTTPD_CONF.bak

# Modification du fichier httpd.conf
sed -i '100s/.*/ServerName srvlinux.g2:80/' $HTTPD_CONF
sed -i '149s/.*/Options FollowSymLinks/' $HTTPD_CONF
sed -i '156s/.*/AllowOverride All/' $HTTPD_CONF
sed -i '169s/.*/DirectoryIndex index.html index.php index.cgi/' $HTTPD_CONF
echo "# server's response header" >> $HTTPD_CONF
echo "ServerTokens Prod" >> $HTTPD_CONF

# Suppression de la page par défaut
rm /etc/httpd/conf.d/welcome.conf

# Création du VirtualHost avec SSL - Page principale
cat << EOF > /etc/httpd/conf.d/main.conf
<VirtualHost *:80>
    ServerName $SERVERNAME.$DOMAIN
    ServerAlias www.$SERVERNAME.$DOMAIN
    Redirect permanent / https://$SERVERNAME.$DOMAIN/
</VirtualHost>
<VirtualHost _default_:443>
    ServerName $PRIMARYUSER.$SERVERNAME.$DOMAIN
    DocumentRoot /srv/web/
    SSLEngine On
    SSLCertificateFile /etc/ssl/certs/httpd-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/certs/httpd-selfsigned.key
</VirtualHost>  
ServerTokens Prod                       
EOF

# Création du VirtualHost avec SSL - Page utilisateur
cat << EOF > /etc/httpd/conf.d/$PRIMARYUSER.conf
<VirtualHost *:80>
    ServerName $PRIMARYUSER.$SERVERNAME.$DOMAIN
    Redirect permanent / https://$PRIMARYUSER.$SERVERNAME.$DOMAIN/
</VirtualHost>
<VirtualHost _default_:443>
    ServerName $PRIMARYUSER.$SERVERNAME.$DOMAIN
    DocumentRoot /srv/web/$PRIMARYUSER
    SSLEngine On
    SSLCertificateFile /etc/ssl/certs/httpd-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/certs/httpd-selfsigned.key
</VirtualHost>                         
EOF

# Création de la page utilisateur
cat << EOF > /srv/web/$PRIMARYUSER/index.php
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>$PRIMARYUSER Page</title>
    </head>
    <body>
        <h1>Bienvenue sur la page de $PRIMARYUSER</h1>
    </body>
</html>
EOF

# Création de la page principale
cat << EOF > /srv/web/index.html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Page principale</title>
    </head>
    <body>
        <h1>Bienvenue sur la page principale</h1>
    </body>
</html>
EOF

semanage fcontext -a -e /var/www /srv/web
restorecon -Rv /srv

# Test de la configuration
apachectl configtest
