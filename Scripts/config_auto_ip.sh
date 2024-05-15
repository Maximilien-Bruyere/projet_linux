#!/bin/bash

# Chargement du fichier pour récupérer les variables
source config.cfg

# Configuration IP nmcli
sudo nmcli con mod "$INTERFACE" ipv4.addresses "$IPADDR/24"
sudo nmcli con mod "$INTERFACE" ipv4.gateway "$GATEWAY"
sudo nmcli con mod "$INTERFACE" ipv4.dns "$DNS1,$DNS2"
sudo nmcli con mod "$INTERFACE" ipv4.method manual

# Redémarrage de NetworkManager
sudo systemctl restart NetworkManager