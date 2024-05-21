#!/bin/bash

# Installation des paquets nécessaires 
sudo dnf -y install nfs-utils
sudo dnf -y install samba
sudo dnf -y install bind
sudo dnf -y install chrony
sudo dnf -y install fail2ban
sudo dnf -y install vsftpd
sudo dnf -y install clamav
sudo dnf -y install lynx
sudo dnf -y --nogpgcheck install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo dnf -y --nogpgcheck install https://rpms.remirepo.net/enterprise/remi-release-9.rpm
sudo dnf -y --nogpgcheck install https://rpms.remirepo.net/enterprise/9/remi/x86_64/php-fedora-autoloader-1.0.1-2.el9.remi.noarch.rpm

# Installation LAMP
sudo dnf install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo dnf install mariadb-server --allowerasing -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation
sudo dnf install php php-mysqlnd -y
sudo systemctl restart httpd