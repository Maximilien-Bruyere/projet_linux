#!/bin/bash
echo -e "\nConfiguration IPTABLES"
echo -e "----------------------\n"

# Configuration et désactivation 
sudo systemctl disable firewalld.service
sudo systemctl stop firewalld.service
sudo dnf remove firewalld.service

# Suppression des règles existantes
iptables -F

# Trafic entrant port 6969 (SSH)
iptables -A INPUT -p tcp --dport 6969 -j ACCEPT
iptables -A INPUT -p udp --dport 6969 -j ACCEPT

# Trafic sortant port 6969 (SSH)
iptables -A OUTPUT -p tcp --sport 6969 -j ACCEPT
iptables -A OUTPUT -p udp --sport 6969 -j ACCEPT

# Autoriser le ping entrant
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT

# Autoriser le ping sortant
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

# Trafic entrant pour NFS (2049)
iptables -A INPUT -p tcp --dport 2049 -j ACCEPT
iptables -A INPUT -p udp --dport 2049 -j ACCEPT

# Trafic entrant pour HTTP (80) et HTTPS (443)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Trafic sortant pour HTTP (80) et HTTPS (443)
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT

# Trafic entrant pour Samba (137-139, 445)
iptables -A INPUT -p tcp --dport 137:139 -j ACCEPT
iptables -A INPUT -p udp --dport 137:139 -j ACCEPT
iptables -A INPUT -p tcp --dport 445 -j ACCEPT
iptables -A INPUT -p udp --dport 445 -j ACCEPT

# Trafic entrant pour BIND (53)
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Trafic entrant pour Chrony (123)
iptables -A INPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT

# Trafic entrant pour MySQL (3306)
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT

# Trafic entrant pour FTP (20, 21)
iptables -A INPUT -p tcp -m multiport --dports 21 -m comment --comment "VSFTP connection" -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 20 -m comment --comment "VSFTP File Transfer" -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp -m tcp --sport 1024:65535 --dport 20:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dport 21 -m comment --comment "VSFTP Connect 2" -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dport 20 -m comment --comment "VSFTP Transfer 2 " -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --sport 1024:65535 --dport 20:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# Trafic entrant pour ClamAV (3310)
iptables -A INPUT -p tcp --dport 3310 -j ACCEPT

# Connexion pour SMTP (25)
iptables -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -A INPUT -p tcp --sport 25 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 25 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 25 -j ACCEPT

# Connexion pour POP (110)
iptables -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -A INPUT -p tcp --sport 110 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 110 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 110 -j ACCEPT

# Connexion pour IMAP (143)
iptables -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -A INPUT -p tcp --sport 143 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 143 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 143 -j ACCEPT

# Connexion pour ROUNDCUBEMAIL (587)
iptables -A INPUT -p tcp --dport 587 -j ACCEPT
iptables -A INPUT -p tcp --sport 587 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 587 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 587 -j ACCEPT

# Connexion pour MariaDB (3306)
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --sport 3306 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 3306 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 3306 -j ACCEPT

# Connexions déjà établies 
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Connexion au loopback (nslookup)
iptables -I INPUT 1 -i lo -j ACCEPT

# Bloquer tout le trafic qui n'est pas autorisé
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

echo -e "\nConfiguration IPTABLES terminée"
echo -e "-------------------------------\n"