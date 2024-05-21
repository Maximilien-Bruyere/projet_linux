#!/bin/bash

# Mettre les permissions pour exécuter les fichiers
sudo find /etc/Scripts -type f -exec chmod 700 {} \;

# Déplacement des exécutables admin dans /sbin
cd /etc/Scripts/scripts_useradd
chown root:root user_add.sh
chmod 755 user._sh
mv user_add.sh /sbin/user_add

# Configuration IP - GOOD
cd /etc/Scripts/scripts_ip
source ip.sh

# Installation des paquets - GOOD
cd /etc/Scripts/scripts_install
source install.sh
echo "Test pour voir si tous les paquets ont été correctement installés"
source install.sh

# Configuration du service BIND - GOOD
cd /etc/Scripts/scripts_dns
source dns.sh

# Configuration du service Chrony - GOOD
cd /etc/Scripts/scripts_chrony
source chrony.sh

# Configuration du service NFS - GOOD
cd /etc/Scripts/scripts_nfs
source nfs.sh

# Configuration du service SMB - GOOD
cd /etc/Scripts/scripts_samba
source samba.sh

# Configuration du service VSFTP - GOOD
cd /etc/Scripts/scripts_vsftpd
source vsftpd.sh

# Configuration du service HTTPD / PHPMYADMIN - PAS GOOD
#cd /etc/Scripts/scripts_httpd
#source httpd.sh
#source phpmyadmin.sh

# Configuration du service ClamAV - GOOD
cd /etc/Scripts/scripts_clamav
source clamav.sh

# Configuration du service Fail2Ban - GOOD (pb systemctl start fail2Ban lors du lancement du script)
cd /etc/Scripts/scripts_fail2ban
source fail2ban.sh

# Configuration du service MAIL - PAS GOOD

# Configuration du pare-feu - GOOD
cd /etc/Scripts/scripts_iptables
source iptables.sh