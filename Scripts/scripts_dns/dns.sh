#!/bin/bash
source ../config.cfg

# 1) Démarrer et activer named
systemctl start named
systemctl enable named

# 2) Configuration de base de /etc/named.conf 
cat << EOF > /etc/named.conf
options {
        listen-on port 53 { $IPADD; }; 
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

zone "$SERVERNAME.$DOMAIN" IN {
        type master;
        file "$SERVERNAME.forward";
        allow-update {none; };
};

zone "200.168.192.in-addr.arpa" IN {
        type master;
        file "$SERVERNAME.reversed";
        allow-update {none;};
};
EOF

# 3) Configuration de base des fichiers de zone
cat << EOF > /var/named/$SERVERNAME.forward
\$TTL 86400
@   IN  SOA     $DOMAIN. root.$SERVERNAME.$DOMAIN. (
        2023022101  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        IN  NS      $SERVERNAME.$DOMAIN.
        IN  A       $IPADD

$SERVERNAME.$DOMAIN     IN  A       $IPADD
EOF

sudo cat << EOF > /var/named/$SERVERNAME.reversed
\$TTL 86400
@   IN  SOA    $DOMAIN. root.$SERVERNAME.$DOMAIN. (
        2023022101  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        IN  NS      $SERVERNAME.$DOMAIN.

3      IN  PTR     $SERVERNAME.$DOMAIN.
EOF

# définir bind juste pour l'IPv4
sudo echo 'OPTIONS="-4"' >> /etc/sysconfig/named

# changer les permissions des fichiers créés
sudo chown named:named /var/named/$SERVERNAME.forward
sudo chmod 640 /var/named/$SERVERNAME.forward
sudo chown named:named /var/named/$SERVERNAME.reversed
sudo chmod 640 /var/named/$SERVERNAME.reversed

# 4) Recharger named 
sudo systemctl restart named 

# 5) Changer les serveurs DNS par notre serveur DNS
sudo nmcli con mod $INTERFACE ipv4.dns "$IPADD"

# 6) Changer le fichier /etc/resolv.conf 
sudo echo "nameserver $IPADD" > /etc/resolv.conf

# 7) Tester si ça marche 
nslookup $DOMAIN
