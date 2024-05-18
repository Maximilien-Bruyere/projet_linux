#!/bin/bash

# Mettre les permissions pour exécuter les fichiers
sudo find /etc/Scripts -type f -exec chmod 700 {} \;

# Configuration IP 
sudo source scripts_ip/ip.sh

# Installation des paquets 
sudo source scripts_install/install.sh 

# Configuration du DNS 
sudo source scripts_dns/dns.sh

# Configuration du pare-feu
sudo source scripts_iptables/iptables.sh