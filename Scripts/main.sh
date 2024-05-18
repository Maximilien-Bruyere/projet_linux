#!/bin/bash

# Mettre les permissions pour exécuter les fichiers
sudo find /etc/Scripts -type f -exec chmod 700 {} \;

# Configuration IP
cd /etc/Scripts/scripts_ip
source ip.sh

# Installation des paquets 
cd /etc/Scripts/scripts_install
source install.sh

# Configuration du DNS
cd /etc/Scripts/scripts_dns
source dns.sh

# Configuration du pare-feu
cd /etc/Scripts/scripts_iptables
source iptables.sh