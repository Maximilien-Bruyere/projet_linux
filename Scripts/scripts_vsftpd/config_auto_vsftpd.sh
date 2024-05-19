#!/bin/bash 
# Fichier de configuration créé dans le but d'automatiser
# l'installation de vsftpd sur un serveur.

source ../config.cfg

echo ""
echo "Installation de vsftpd"
echo "----------------------"
echo ""
systemctl start vsftpd
systemctl enable vsftpd

echo ""
echo "Configuration de vsftpd"
echo "------------------------"
echo ""

