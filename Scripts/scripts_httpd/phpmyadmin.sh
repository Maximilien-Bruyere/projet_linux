#!/bin/bash
# Fichier de configuration créé dans le but d'automatiser
# l'installation de phpMyAdmin sur un serveur.

source ../config.cfg


echo ""
echo "Installation de phpMyAdmin"
echo "--------------------------"
echo ""

sudo mkdir -p /var/lib/phpmyadmin/tmp
sudo chown -R apache:apache /var/lib/phpmyadmin
sudo cd /usr/share/phpmyadmin/
sudo cp config.sample.inc.php  config.inc.php

sudo ln -s /usr/share/phpMyAdmin/ /srv/web/$PRIMARYUSER/

service httpd restart