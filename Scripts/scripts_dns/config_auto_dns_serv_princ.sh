#!/bin/bash

# Variables
ip_serveur="192.168.200.10"
nom_du_serv="srv_linux"
domaine="lan"

# 1) Démarrer et activer named
systemctl start named
systemctl enable named

# 2) Configuration de base de /etc/named.conf 
cat << EOF > /etc/named.conf
options {
        listen-on port 53 { $ip_serveur; }; 
        listen-on-v6 port 53 { none; }; 
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        allow-query     { any; };
        recursion yes;

        dnssec-enable no;
        dnssec-validation no;

        forwarders {
                8.8.8.8;  // Serveur DNS Google
                1.1.1.1;  // Serveur DNS Cloudflare
        };

        managed-keys-directory "/var/named/dynamic";
        geoip-directory "/usr/share/GeoIP";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";

        include "/etc/crypto-policies/back-ends/bind.config";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";

zone "$nom_du_serv.$domaine" IN {
        type master;
        file "$nom_du_serv.forward";
        allow-update {none; };
};

zone "200.168.192.in-addr.arpa" IN {
        type master;
        file "$nom_du_serv.reversed";
        allow-update {none;};
};
EOF

# 3) Configuration de base des fichiers de zone
cat << EOF > /var/named/$nom_du_serv.forward
$TTL 86400
@   IN  SOA     $domaine. root.$nom_du_serv.$domaine. (
        2023022101  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        IN  NS      $nom_du_serv.$domaine.
        IN  A       $ip_serveur

$nom_du_serv.$domaine     IN  A       $ip_serveur
EOF

sudo cat << EOF > /var/named/$nom_du_serv.reversed
$TTL 86400
@   IN  SOA    $domaine. root.$nom_du_serv.$domaine. (
        2023022101  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        IN  NS      $nom_du_serv.$domaine.

3      IN  PTR     $nom_du_serv.$domaine.
EOF

# définir bind juste pour l'IPv4
sudo echo 'OPTIONS="-4"' >> /etc/sysconfig/named

# 4) Recharger named 
sudo systemctl restart named 

# 6) Changer le fichier /etc/resolv.conf 
sudo echo "nameserver $ip_serveur" > /etc/resolv.conf

# 7) Tester si ça marche 
nslookup $domaine
