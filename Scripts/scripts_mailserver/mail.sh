
#!/bin/bash
# Fichier de configuration créé dans le but d'automatiser la mise en place d'un serveur mail
#
echo "Installation de postfix"
echo "-------------------------"
echo ""

dnf -y install postfix


sed -i '95c\myhostname = mail.srvlinux.g2' /etc/postfix/main.cf
sed -i '102c\mydomain = srvlinux.g2' /etc/postfix/main.cf
sed -i '118c\myorigin = $mydomain' /etc/postfix/main.cf
sed -i '135c\inet_interfaces = all' /etc/postfix/main.cf
sed -i '138c\inet_protocols = ipv4' /etc/postfix/main.cf
sed -i '183c\mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain' /etc/postfix/main.cf
sed -i '283c\mynetworks = 127.0.0.0/8, 192.168.1.0/24' /etc/postfix/main.cf
sed -i '438c\home_mailbox = Maildir/' /etc/postfix/main.cf
sed -i '593c\smtpd_banner = $myhostname ESMTP' /etc/postfix/main.cf
echo 'smtpd_sasl_type = dovecot' >> /etc/postfix/main.cf
echo 'smtpd_sasl_path = private/auth' >> /etc/postfix/main.cf
echo 'smtpd_sasl_auth_enable = yes' >> /etc/postfix/main.cf
echo 'smtpd_sasl_security_options = noanonymous' >> /etc/postfix/main.cf
echo 'smtpd_sasl_local_domain = $myhostname' >> /etc/postfix/main.cf
echo 'broken_sasl_auth_clients = yes' >> /etc/postfix/main.cf
echo 'smtpd_recipient_restrictions = permit_sasl_authenticated, permit_mynetworks, reject_unauth_destination' >> /etc/postfix/main.cf

systemctl enable --now postfix

echo 'Installation de dovecot'
echo "-------------------------"
echo ""

dnf -y install dovecot

sed -i '30c\listen = *' /etc/dovecot/dovecot.conf
sed -i '10c\disable_plaintext_auth = no' /etc/dovecot/conf.d/10-auth.conf
sed -i '100c\auth_mechanisms = plain login' /etc/dovecot/conf.d/10-auth.conf
sed -i '30c\mail_location = maildir:~/Maildir' /etc/dovecot/conf.d/10-mail.conf
sed -i '107c\  unix_listener /var/spool/postfix/private/auth {' /etc/dovecot/conf.d/10-master.conf
sed -i '108c\    mode = 0666 \n' /etc/dovecot/conf.d/10-master.conf
sed -i '109c\    user = postfix \n' /etc/dovecot/conf.d/10-master.conf
sed -i '110c\    group = postfix \n' /etc/dovecot/conf.d/10-master.conf
sed -i '111c\  }' /etc/dovecot/conf.d/10-master.conf
sed -i '8c \ssl = yes' /etc/dovecot/conf.d/10-ssl.conf

echo "Installation de Php"
echo "-------------------------"
echo ""

# installation de php

dnf -y install php 

systemctl restart httpd
systemctl status php-fpm

# création d'une page de test php

echo '<?php phpinfo(); ?>' > /srv/web/info.php

echo "Installation de mariadb"
echo "-------------------------"
echo ""

# installation de mariadb

dnf -y install mariadb-server

# https://www.server-world.info/en/note?os=AlmaLinux_9&p=mariadb&f=1 (pout les tests )

# creation de la base de donnée pour roundcube
mysql -u root -p

CREATE DATABASE roundcubemail DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON roundcubemail.* TO 'roundcubeuser'@'localhost' IDENTIFIED BY 'AdminG2*';
FLUSH PRIVILEGES;
EXIT;

# installation de roundcube 

wget https://github.com/roundcube/roundcubemail/releases/download/1.6.0/roundcubemail-1.6.0-complete.tar.gz
tar -xvf roundcubemail-1.6.0-complete.tar.gz
mv roundcubemail-1.6.0 /srv/web/roundcubemail
cd /srv/web/roundcubemail
# composer install --no-dev

nano /etc/httpd/conf.d/roundcubemail.conf

Alias /roundcubemail /srv/web/roundcubemail 

<Directory /srv/web/roundcubemail>
    Options -Indexes
    AllowOverride All
    Require all granted
</Directory>


systemctl restart httpd