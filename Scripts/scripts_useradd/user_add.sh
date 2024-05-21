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
chmod -R 750 /srv/web/$user

# Créez la base de données pour l'utilisateur
#mysql -u root -p -e "CREATE DATABASE ${user}_db; CREATE USER '${user}'@'localhost' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON ${user}_db.* TO '${user}'@'localhost'; FLUSH PRIVILEGES;"
# Créez la base de données pour l'utilisateur
mysql -e "CREATE DATABASE IF NOT EXISTS ${user}_db;"
mysql -e "GRANT ALL PRIVILEGES ON ${user}_db.* TO '${user}'@'localhost' IDENTIFIED BY 'password';"
mysql -e "FLUSH PRIVILEGES;"

# Configurez l'accès FTP pour l'utilisateur
sudo echo $user >> /etc/vsftpd/chroot_list

# Configurez l'accès Samba pour l'utilisateur
(echo $user; echo $user) | smbpasswd -a $user
echo -e "[$user]\npath = /srv/web/$user\nvalid users = $user\nread only = no" >> /etc/samba/smb.conf

sudo echo "[$user]" >> /etc/samba/smb.conf
sudo echo -e "\tpath = /srv/web/$user" >> /etc/samba/smb.conf
sudo echo -e "\twritable = yes" >> /etc/samba/smb.conf
sudo echo -e "\tguest ok = no" >> /etc/samba/smb.conf
sudo echo -e "\tvalid users = $user" >> /etc/samba/smb.conf
sudo restorecon -R /srv/web/$user

systemctl restart smb