#!/bin/bash

# Fichier de configuration créé dans le but d'automatiser la mise en place de ClamAV
# pour sécuriser un serveur.

echo "Configuration de ClamAV"
echo "-------------------------"
echo ""

# Installation de ClamAV

sudo dnf install clamav clamd -y
dnf --enablerepo=epel -y install clamav clamav-update

# Configuration de ClamAV

# nano /etc/freshclam.conf     # si tu veux look le fichier de conf
# nano /etc/clamd.d/scan.conf  # si tu veux look le fichier de conf

mkdir /var/log/clamav
touch /var/log/clamav/clamav-scan.log

sudo bash -c "(crontab -l 2>/dev/null; echo '30 12 * * * /usr/bin/clamscan -ri / >> /var/log/clamav/clamav-scan.log') | crontab -"
sudo bash -c "(crontab -l 2>/dev/null; echo '0 12 3 * * freshclam') | crontab -"

echo "Configuration de ClamAV terminée."
echo "-------------------------"
echo ""
 <