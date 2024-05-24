#!/bin/bash
echo -e "\nConfiguration de NAMED"
echo -e "----------------------\n"

source ../config.cfg
systemctl start named
systemctl enable named

# Configuration du named.conf
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

zone "1.168.192.in-addr.arpa" IN {
        type master;
        file "$SERVERNAME.reversed";
        allow-update {none;};
};
EOF

# Configuration des fichiers de zone
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

cat << EOF > /var/named/$SERVERNAME.reversed
\$TTL 86400
@   IN  SOA    $DOMAIN. root.$SERVERNAME.$DOMAIN. (
        2023022101  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        IN  NS      $SERVERNAME.$DOMAIN.

$LAST8BITS      IN  PTR     $SERVERNAME.$DOMAIN.
EOF

# Utilisation de bind juste pour l'IPv4
echo 'OPTIONS="-4"' >> /etc/sysconfig/named

chown named:named /var/named/$SERVERNAME.forward
chmod 640 /var/named/$SERVERNAME.forward
chown named:named /var/named/$SERVERNAME.reversed
chmod 640 /var/named/$SERVERNAME.reversed

# Rechargement du cache DNS chaque heure
bash -c "(crontab -l 2>/dev/null; echo '0 * * * *  rndc dumpdb -cache') | crontab -"
bash -c "(crontab -l 2>/dev/null; echo '* 17 * * *  rndc flush') | crontab -"

systemctl restart named 

# Changement du fichier /etc/resolv.conf 
echo "nameserver $IPADD" > /etc/resolv.conf

echo -e "\nConfiguration de NAMED terminée"
echo -e "-------------------------------\n"
