#!/bin/bash
echo -e "\nConfiguration de phpMyAdmin"
echo -e "---------------------------\n"

mkdir -p /var/lib/phpmyadmin/tmp
chown -R apache:apache /var/lib/phpmyadmin
cd /usr/share/phpmyadmin/
cp config.sample.inc.php  config.inc.php

ln -s /usr/share/phpMyAdmin/ /srv/web/phpmyadmin

service httpd restart

echo -e "\nConfiguration de phpMyAdmin terminée"
echo -e "------------------------------------\n"