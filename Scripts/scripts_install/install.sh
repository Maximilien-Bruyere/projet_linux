#!/bin/bash

# Installation des paquets nécessaires 
sudo dnf -y install nfs-utils
sudo dnf -y install httpd
sudo dnf -y install samba
sudo dnf -y install bind
sudo dnf -y install chrony
sudo dnf -y install mysql-server
sudo dnf -y install php php-mbstring php-xml 
sudo dnf -y install epel-release
sudo dnf -y install fail2ban
sudo dnf -y install vsftpd
sudo dnf -y install clamav
sudo dnf -y install lynx