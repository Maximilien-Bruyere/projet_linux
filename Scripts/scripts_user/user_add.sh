#!/bin/bash
# /sbin/user_add

# Vérification des permissions d'exécution
if [ "$(id -u)" != "0" ]; then
   echo "Ce script doit être exécuté en tant que root" 1>&2
   exit 1
fi

read -p "Entrez le nom de l'utilisateur : " user

# Création de l'utilisateur
echo -e "\n- Création de l'utilisateur ...\n"
useradd $user

# Mise en place d'un mot de passe pour l'utilisateur
echo -e "\n- Choix du mot de passe ...\n"
passwd $user

# Création du répertoire web de l'utilisateur
echo -e "\n- Création du répertoire web de l'utilisateur ...\n"
mkdir -p /srv/web/$user

# Mise en place des permissions
echo -e "\n- Mise en place des permissions ...\n"
chown -R $user:$user /srv/web/$user
chmod -R 755 /srv/web/$user
setquota -u $user 2500 3000 0 0 /dev/mapper/luks-6c2f1231-b5a6-451a-ba5b-a46e3496e9f8
setquota -u $user 2500 3000 0 0 /dev/mapper/luks-8376455c-27b4-4392-b166-3b0466afda33
#

# Création de la base de données pour l'utilisateur
echo -e "\n- Création de la base de données ...\n"
read -p "Entrez votre mot de passe pour la base de données : " passwd
mysql -e "CREATE DATABASE IF NOT EXISTS ${user}_db;"
mysql -e "GRANT ALL PRIVILEGES ON ${user}_db.* TO '${user}'@'localhost' IDENTIFIED BY '${passwd}';"
mysql -e "FLUSH PRIVILEGES;"

# Configuration de l'accès Samba pour l'utilisateur
echo -e "\n- Configuration de l'accès Samba ...\n"
sudo smbpasswd -a $user
sudo echo "[$user]" >> /etc/samba/smb.conf
sudo echo -e "\tpath = /srv/web/$user" >> /etc/samba/smb.conf
sudo echo -e "\twritable = yes" >> /etc/samba/smb.conf
sudo echo -e "\tguest ok = no" >> /etc/samba/smb.conf
sudo echo -e "\tvalid users = $user" >> /etc/samba/smb.conf
sudo restorecon -R /srv/web/$user

# Création de la page utilisateur
echo -e "\n- Création de la page utilisateur ...\n"
cat << EOF > /srv/web/$user/index.php
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>$user Page</title>
    </head>
    <body>
        <h1>Bienvenue sur la page de $user</h1>
        <a href="phpMyAdmin/index.php">Lien Base de données </a>
    </body>
</html>
EOF

# Création du VirtualHost de l'utilisateur
echo -e "\n- Création du VirtualHost ...\n"
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

# Mettez en place des permissions
echo -e "\n- Mise en place des permissions ...\n"
chown $user:$user /srv/web/$user/index.php
chmod 644 /srv/web/$user/index.php
restorecon -Rv /srv

sudo ln -s /usr/share/phpMyAdmin/ /srv/web/$user/

# Redémarrage des services nécessaires
echo -e "- Redémarrage des services ...\n"
systemctl restart named 
systemctl restart httpd

systemctl restart smb