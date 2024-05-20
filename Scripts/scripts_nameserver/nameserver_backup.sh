#!/bin/bash

source ../config.cfg

# Utiliser hostnamectl pour changer le nom d'hôte
sudo hostnamectl set-hostname $SERVERNAMEBACKUP

# Modifier le fichier /etc/hostname
echo $SERVERNAMEBACKUP | sudo tee /etc/hostname

# Modifier le fichier /etc/hosts
sudo sed -i "s/$(hostname)/$SERVERNAMEBACKUP/g" /etc/hosts

sudo shutdown -r now
