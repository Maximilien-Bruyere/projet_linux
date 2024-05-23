#!/bin/bash

# Fichier de configuration créé dans le but d'automatiser la mise en place de fail2ban
# pour sécuriser un serveur.


echo "Configuration de fail2ban"
echo "-------------------------"
echo ""

# lancement de fail2ban
dbf install fail2ban -y
systemctl start fail2ban
systemctl enable fail2ban
systemctl status fail2ban

# Configuration de fail2ban 

cd /etc/fail2ban

echo "[DEFAULT]" > jail.local
echo "bantime = 120" >> jail.local
echo "maxretry = 3 " >> jail.local
echo "[sshd] = true " >> jail.local
echo "enabled = true" >> jail.local

echo "Configuration de fail2ban terminée."
systemctl restart fail2ban

# Vérification de la configuration
fail2ban-client status

echo "Configuration de fail2ban terminée."
systemctl restart fail2ban
systemctl start fail2ban