#!/bin/bash
# Fichier de configuration créé dans le but d'automatiser
# l'installation de phpMyAdmin sur un serveur.

source ../config.cfg


echo ""
echo "Installation de phpMyAdmin"
echo "--------------------------"
echo ""
# installation des paquets nécessaires et ajoute des repository
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf install https://rpms.remirepo.net/enterprise/remi-release-9.rpm
dnf install https://rpms.remirepo.net/enterprise/9/remi/x86_64/php-fedora-autoloader-1.0.1-2.el9.remi.noarch.rpm

# En cas de  soucis 

#sudo dnf install --nogpgcheck https://rpms.remirepo.net/enterprise/remi-release-9.rpm
#dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf --enablerepo=remi install phpMyAdmin

# Configuration de phpMyAdmin
service httpd restart

echo "# phpMyAdmin - Web based MySQL browser written in php" > /etc/httpd/conf.d/phpMyAdmin.conf
echo "# " >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "# Allows only localhost by default" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "#" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "# But allowing phpMyAdmin to anyone other than localhost should be considered" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "# dangerous unless properly secured by SSL" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "Alias /phpMyAdmin /usr/share/phpMyAdmin" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "Alias /phpmyadmin /usr/share/phpMyAdmin" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "<Directory /usr/share/phpMyAdmin/> " >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "   AddDefaultCharset UTF-8" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "   <IfModule mod_authz_core.c>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "     # Apache 2.4" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "     <RequireAny>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "       #Require ip 127.0.0.1" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "       #Require ip ::1" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "       Require all granted" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "     </RequireAny>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "   </IfModule>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "   <IfModule !mod_authz_core.c>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "     # Apache 2.2" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "     Order Deny,Allow" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "     Deny from All" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "     Allow from 127.0.0.1" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "     Allow from ::1" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "   </IfModule>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "</Directory>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "" >> /etc/httpd/conf.d/phpMyAdmin.conf 
echo "<Directory /usr/share/phpMyAdmin/setup/>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "   Require local" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "</Directory>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "# These directories do not require access over HTTP - taken from the original" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "# phpMyAdmin upstream tarball" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "#" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "<Directory /usr/share/phpMyAdmin/libraries/>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "    Require all denied" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "</Directory>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "<Directory /usr/share/phpMyAdmin/templates/>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "    Require all denied" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "</Directory>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "<Directory /usr/share/phpMyAdmin/setup/lib/>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "    Require all denied" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "</Directory>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "<Directory /usr/share/phpMyAdmin/setup/frames/>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "    Require all denied" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "</Directory>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "# This configuration prevents mod_security at phpMyAdmin directories from" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "# filtering SQL etc.  This may break your mod_security implementation." >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "#" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "#<IfModule mod_security.c>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "#    <Directory /usr/share/phpMyAdmin/>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "#        SecRuleInheritance Off" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "#    </Directory>" >> /etc/httpd/conf.d/phpMyAdmin.conf
echo "#</IfModule>" >> /etc/httpd/conf.d/phpMyAdmin.conf

# Création d'un lien symbolique
ln -s /usr/share/phpMyAdmin/ /srv/web/phpMyAdmin



