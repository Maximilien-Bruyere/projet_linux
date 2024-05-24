#!/bin/bash

# Vérification des permissions d'exécution
if [ "$(id -u)" != "0" ]; then
   echo "Ce script doit être exécuté en tant que root" 1>&2
   exit 1
fi

read -p "Entrez le nom de l'utilisateur à supprimer : " user

# Suppression de l'utilisateur
echo -e "\n- Suppression de l'utilisateur ...\n"
userdel -r $user

# Suppression de la base de données de l'utilisateur
echo -e "\n- Suppression de la base de données ...\n"
mysql -e "DROP DATABASE IF EXISTS ${user}_db;"
mysql -e "DROP USER IF EXISTS '${user}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Suppression du répertoire web de l'utilisateur
echo -e "\n- Suppression du répertoire web de l'utilisateur ...\n"
rm -rf /srv/web/$user

# Suppression du compte Samba de l'utilisateur
echo -e "\n- Suppression du compte Samba de l'utilisateur ...\n"
smbpasswd -x $user

# Suppression du VirtualHost de l'utilisateur
echo -e "\n- Suppression du VirtualHost de l'utilisateur ...\n"
rm -f /etc/httpd/conf.d/$user.conf

# Suppression de l'entrée DNS de l'utilisateur
echo -e "\n- Suppression de l'entrée DNS de l'utilisateur ...\n"
sed -i "/^$user\tIN\tCNAME\tsrvlinux.g2$/d" /var/named/srvlinux.forward

# Redémarrage des services nécessaires
echo -e "- Redémarrage des services ...\n"
systemctl restart named
systemctl restart httpd
systemctl restart smb

echo -e "\nL'utilisateur $user et toutes ses configurations associées ont été supprimés avec succès.\n"

