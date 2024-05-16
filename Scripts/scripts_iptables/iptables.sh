#!/bin/bash

# Configuration et désactivation 
sudo systemctl disable firewalld.service
sudo systemctl stop firewalld.service
sudo dnf remove firewalld.service

# Installation des paquets nécessaires 

sudo dnf -y install nfs-utils
sudo dnf -y install httpd
sudo dnf -y install samba
sudo dnf -y install bind
sudo dnf -y install chrony
sudo dnf -y install mysql-server
sudo dnf -y install php php-mbstring php-xml 
sudo dnf -y install epel-release
sudo dnf -y install fail2ban
sudo dnf -y install vsftpd
sudo dnf -y install clamav

# Suppression des règles existantes
iptables -F

# Trafic entrant port 22 (SSH)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p udp --dport 22 -j ACCEPT

# Trafic sortant port 22 (SSH)
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
iptables -A OUTPUT -p udp --sport 22 -j ACCEPT

# Autoriser le ping entrant
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT

# Autoriser le ping sortant
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

# Autoriser le trafic DNS
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT

# Autoriser le trafic HTTP et HTTPS sortant
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT

# Bloquer tout le trafic qui n'est pas autorisé
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

