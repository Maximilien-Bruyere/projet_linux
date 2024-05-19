#!/bin/bash
# Fichier de configuration créé dans le but d'automatiser
# l'installation et la configuration du service chrony.
source ../config.cfg
# Mettre le serveur sur le bon fuseau horaire
echo "-------------------------"
echo -e "\nMise en service de Chrony\n"
# Démarrage du service chrony
echo "- Démarrage du service chrony ..."
sudo timedatectl set-timezone Europe/Brussels
sudo systemctl start chronyd
sudo systemctl enable chronyd
# Configuration du service chrony
echo "- Configuration du service chrony ..."
sudo echo "allow $ADDRESS/$MASK" >> /etc/chrony.conf
sudo echo "allow $IPCLIENT" >> /etc/chrony.conf
sudo echo "server $IPADD iburst" >> /etc/chrony.conf
# Ajout des serveurs de temps (BE)
echo "- Ajout des serveurs de temps (BE) ..."
sudo echo "server 0.be.pool.ntp.org iburst" >> /etc/chrony.conf
sudo echo "server 1.be.pool.ntp.org iburst" >> /etc/chrony.conf
sudo echo "server 2.be.pool.ntp.org iburst" >> /etc/chrony.conf
sudo echo "server 3.be.pool.ntp.org iburst" >> /etc/chrony.conf
# Redémarrage du service chrony
echo "- Redémarrage du service chrony ..."
sudo systemctl restart chronyd
# Synchonisation avec les serveurs universels de temps
echo "- Synchronisation avec les serveurs BE ..."
sudo timedatectl set-ntp true
echo -e "- Fin de la configuration ...\n"
echo "Le service Chrony a été configuré avec succès."
echo -e "\n-------------------------"