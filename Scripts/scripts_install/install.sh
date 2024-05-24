#!/bin/bash
echo -e "\nInstallation des paquets nécessaires"
echo -e "------------------------------------\n"

# Installation des paquets nécessaires 
dnf -y install nfs-utils
dnf -y install samba
dnf -y install bind
dnf -y install chrony
dnf -y install fail2ban
dnf -y install vsftpd
dnf -y install rsync
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf -y install https://rpms.remirepo.net/enterprise/remi-release-9.rpm
dnf -y install https://rpms.remirepo.net/enterprise/9/remi/x86_64/php-fedora-autoloader-1.0.1-2.el9.remi.noarch.rpm
dnf -y install clamav clamd 
dnf -y --enablerepo=epel install clamav clamav-update

dnf -y install httpd 
systemctl start httpd
systemctl enable httpd
dnf -y --allowerasing install mariadb-server
systemctl start mariadb
systemctl enable mariadb
dnf -y install php phpmyadmin php-mysqlnd 
systemctl restart httpd
dnf -y install mod_ssl 
mysql_secure_installation
dnf -y install postfix
dnf -y install dovecot

echo -e "\nFin des installations"
echo -e "---------------------\n"