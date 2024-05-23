#!/bin/bash
# Fichier de configuration créé dans le but d'automatiser
# l'installation de phpMyAdmin sur un serveur.

source ../config.cfg


echo ""
echo "Installation de phpMyAdmin"
echo "--------------------------"
echo ""

# installation des paquets nécessaires et ajoute des repository
service httpd restart

sudo ln -s /usr/share/phpMyAdmin/ /srv/web/phpmyadmin


