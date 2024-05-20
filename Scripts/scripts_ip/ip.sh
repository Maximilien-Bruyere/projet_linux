#!/bin/bash
# Fichier de configuration créé dans le but d'automatiser
# la mise en réseau d'un serveur pour installer
# les services ainsi que les paquets nécessaires pour
# son bon fonctionnement.
#
#
source ../config.cfg
#
#
echo ""
echo "Mise en réseau"
echo "--------------"
echo ""
echo "Configuration du serveur :"
echo "- INTERFACE : $INTERFACE"
echo "- IPV4 : $IPADD/24"
echo "- GATEWAY : $GATEWAY"
echo "- DNS PRIMAIRE : $DNS1"
echo "- DNS SECONDAIRE : $DNS2"
echo ""
#
sudo hostnamectl set-hostname $SERVERNAME
#
sudo systemctl restart NetworkManager
#
#
echo -e "\nTest du réseau"
echo -e "--------------\n"
hosts=("www.google.com" "www.github.com")
echo "" >> /var/log/log_ip_test.log
for host in "${hosts[@]}"; do
    echo "Test de la connectivité à $host..."
    echo ""
    # Envoie un seul paquet de ping
    if ping -c 1 $host &> /dev/null; then
	echo "Connexion réussie à $host sur $INTERFACE, $IPADD/24 à $(date)" >> /var/log/log_ip_test.log
        echo -e "Connectivité à $host réussie.\n"
    else
	echo "Connexion échouée à $host sur $INTERFACE, $IPADD/24 à $(date)" >> /var/log/log_ip_test.log
        echo "Échec de la connectivité à $host."
	break
    fi
done
