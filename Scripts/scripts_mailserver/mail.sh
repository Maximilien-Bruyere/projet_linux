
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

dnf -y install php 

systemctl restart httpd
systemctl status php-fpm

echo '<?php phpinfo(); ?>' > /srv/web/info.php

dnf -y install mariadb-server

mysql_secure_installation




