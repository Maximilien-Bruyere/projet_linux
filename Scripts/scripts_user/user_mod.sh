#!/bin/bash
# /sbin/user_mod

# Vérification des permissions d'exécution
if [ "$(id -u)" != "0" ]; then
   echo "Ce script doit être exécuté en tant que root" 1>&2
   exit 1
fi

read -p "Entrez le nom de l'utilisateur que vous voulez modifier : " user

passwd $user

# Suppression de la base de données de l'utilisateur
echo -e "\n- Suppression de la base de données ...\n"
mysql -e "DROP DATABASE IF EXISTS ${user}_db;"
mysql -e "DROP USER IF EXISTS '${user}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Création de la base de données pour l'utilisateur
echo -e "\n- Création de la base de données ...\n"
read -p "Entrez votre mot de passe pour la base de données : " passwd
mysql -e "CREATE DATABASE IF NOT EXISTS ${user}_db;"
mysql -e "GRANT ALL PRIVILEGES ON ${user}_db.* TO '${user}'@'localhost' IDENTIFIED BY '${passwd}';"
mysql -e "FLUSH PRIVILEGES;"

# Configuration de l'accès Samba pour l'utilisateur
echo -e "\n- Configuration de l'accès Samba ...\n"
smbpasswd -a $user
systemctl restart named 
systemctl restart httpd

