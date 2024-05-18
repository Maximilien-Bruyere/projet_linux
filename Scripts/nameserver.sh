#!/bin/bash

source config.cfg

# Utiliser hostnamectl pour changer le nom d'hôte
sudo hostnamectl set-hostname $SERVERNAME

# Modifier le fichier /etc/hostname
echo $SERVERNAME | sudo tee /etc/hostname

# Modifier le fichier /etc/hosts
sudo sed -i "s/$(hostname)/$SERVERNAME/g" /etc/hosts

sudo shutdown -r now
