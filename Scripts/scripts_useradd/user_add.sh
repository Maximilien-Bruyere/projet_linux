#!/bin/bash

# Vérifiez si le script est exécuté en tant que root
if [ "$(id -u)" != "0" ]; then
   echo "Ce script doit être exécuté en tant que root" 1>&2
   exit 1
fi

# Demandez le nom d'utilisateur
read -p "Entrez le nom d'utilisateur : " user

# Créez l'utilisateur
useradd $user

# Définissez le mot de passe de l'utilisateur
passwd $user

# Créez le répertoire pour le domaine de l'utilisateur
mkdir -p /srv/web/$user

# Mettez en place les permissions
chown -R $user:$user /srv/web/$user
chmod -R 755 /srv/web/$user

# Créez la base de données pour l'utilisateur
mysql -e "CREATE DATABASE IF NOT EXISTS ${user}_db;"
mysql -e "GRANT ALL PRIVILEGES ON ${user}_db.* TO '${user}'@'localhost' IDENTIFIED BY 'password';"
mysql -e "FLUSH PRIVILEGES;"

# Configurez l'accès Samba pour l'utilisateur
sudo smbpasswd -a $user

sudo echo "[$user]" >> /etc/samba/smb.conf
sudo echo -e "\tpath = /srv/web/$user" >> /etc/samba/smb.conf
sudo echo -e "\twritable = yes" >> /etc/samba/smb.conf
sudo echo -e "\tguest ok = no" >> /etc/samba/smb.conf
sudo echo -e "\tvalid users = $user" >> /etc/samba/smb.conf
sudo restorecon -R /srv/web/$user

# Créez un fichier HTML de base pour l'utilisateur
cat << EOF > /srv/web/$user/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Bienvenue sur le site de $user</title>
</head>
<body>
    <h1>Bienvenue sur le site de $user</h1>
    <p>Ce site est actuellement en construction.</p>
</body>
</html>
EOF

cat << EOF > /etc/httpd/conf.d/$user.conf
<VirtualHost *:80>
    ServerName $user.srvlinux.g2
    Redirect permanent / https://$user.srvlinux.g2/
</VirtualHost>
<VirtualHost _default_:443>
    ServerName $user.srvlinux.g2
    DocumentRoot /srv/web/$user
    SSLEngine On
    SSLCertificateFile /etc/ssl/certs/httpd-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/certs/httpd-selfsigned.key
</VirtualHost>                         
EOF

echo -e "$user\tIN\tCNAME\tsrvlinux.g2" >> /var/named/srvlinux.forward

# Mettez en place les permissions
chown $user:$user /srv/web/$user/index.html
chmod 644 /srv/web/$user/index.html

systemctl restart named 
systemctl restart httpd

systemctl restart smb


