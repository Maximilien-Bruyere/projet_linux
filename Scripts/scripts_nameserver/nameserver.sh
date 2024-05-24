#!/bin/bash
echo -e "\nConfiguration du NAMESERVER"
echo -e "---------------------------\n"

source ../config.cfg

# Changement du nom d'hôte
hostnamectl set-hostname $SERVERNAME

# Modification du fichier /etc/hostname
echo $SERVERNAME | tee /etc/hostname

# Modification du fichier /etc/hosts
sed -i "s/$(hostname)/$SERVERNAME/g" /etc/hosts

echo -e "\nRedémarrage en cours"
echo -e "--------------------\n"

shutdown -r now
