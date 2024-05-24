#!/bin/bash
echo -e "\nConfiguration de HTTPD"
echo -e "----------------------\n"

source ../config.cfg
systemctl start httpd
systemctl enable httpd

HTTPD_CONF="/etc/httpd/conf/httpd.conf"

# Copie du fichier de base
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

# Création du VirtualHost avec SSL du premier utilisateur (admin)
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

# Création de la page du premier utilisateur (admin)
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

# SELINUX
semanage fcontext -a -e /var/www /srv/web
restorecon -Rv /srv

apachectl configtest

echo -e "\nConfiguration de HTTPD terminée"
echo -e "-------------------------------\n"