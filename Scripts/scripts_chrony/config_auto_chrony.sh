#!/bin/bash
# Fichier de configuration créé dans le but d'automatiser
# l'installation et la configuration du service chrony.

echo "Début de l'installation et de la configuration de chrony"
echo "--------------------------------------------------------"

source ../config.cfg

#démarrage du service chrony
systemctl start chronyd
systemctl enable chronyd

cd /etc/ 

#configuration du service chrony
echo " allow $ADDRESS/$MASK" >> /etc/chrony.conf
echo "server $IPADD iburst" >> /etc/chrony.conf

#redémarrage du service chrony
systemctl restart chronyd

echo "Fin de l'installation et de la configuration de chrony"
echo "-------------------------------------------------------"
echo ""
echo "Test de l'installation et de la configuration de chrony"
echo "-------------------------------------------------------"
echo ""

#test de la configuration du service chrony
chronyc sources -c
chronyc tracking