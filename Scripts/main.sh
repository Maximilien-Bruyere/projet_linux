#!/bin/bash

# Mettre les permissions pour exécuter les fichiers
sudo find /etc/Scripts -type f -exec chmod 700 {} \;

# Déplacement des exécutables admin dans /sbin
cd /etc/Scripts/scripts_useradd
chown root:root user_add.sh
chmod 755 user._sh
mv user_add.sh /sbin/user_add

# Configuration IP
cd /etc/Scripts/scripts_ip
source ip.sh

# Installation des paquets 
cd /etc/Scripts/scripts_install
source install.sh
echo "Test pour voir si tous les paquets ont été correctement installés"
source install.sh

# Configuration du service BIND
cd /etc/Scripts/scripts_dns
source dns.sh

# Configuration du service Chrony
cd /etc/Scripts/scripts_chrony
source chrony.sh

# Configuration du service NFS
cd /etc/Scripts/scripts_nfs
source nfs.sh

# Configuration du service SMB
cd /etc/Scripts/scripts_samba
source samba.sh

# Configuration du service VSFTP
cd /etc/Scripts/scripts_vsftpd
source vsftpd.sh

# Configuration du service HTTPD / PHPMYADMIN
cd /etc/Scripts/scripts_httpd
source phpmyadmin.sh
#source httpd.sh

# Configuration du service ClamAV
cd /etc/Scripts/scripts_clamav
source clamav.sh

# Configuration du service Fail2Ban
cd /etc/Scripts/scripts_fail2ban
source fail2ban.sh

# Configuration du pare-feu
cd /etc/Scripts/scripts_iptables
source iptables.sh