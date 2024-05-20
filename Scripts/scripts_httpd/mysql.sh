#!/bin/bash

# Fichier de configuration créé dans le but d'automatiser la mise en place de MySQL

echo "Installation de MySQL"
echo "-------------------------"
echo ""

# Installation de MySQL

dnf -y install mysql-server mysql
systemctl enable mysqld.service
systemctl start mysqld.service


# Configuration de MySQL

# mysql_secure_installation
# Test123*
# n
# y
# y
# n
# y


# mysql -e "SHOW DATABASES;" -p

