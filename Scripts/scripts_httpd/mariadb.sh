#!/bin/bash

# Fichier de configuration créé dans le but d'automatiser la mise en place de mariadb

echo "Installation de mariadb"
echo "-------------------------"
echo ""

# Installation de mariadb

echo '# MariaDB 10.11 RedHatEnterpriseLinux repository list - created 2024-5-22 14:19 UTC' > /etc/yum.repos.d/mariadb.repo
echo '# https://mariadb.org/download/' >> /etc/yum.repos.d/mariadb.repo
echo '[mariadb]' >> /etc/yum.repos.d/mariadb.repo
echo 'name = MariaDB' >> /etc/yum.repos.d/mariadb.repo
echo '# rpm.mariadb.org is a dynamic mirror if your preferred mirror goes offline. See https://mariadb.org/mirrorbits/ for details.' >> /etc/yum.repos.d/mariadb.repo
echo '# baseurl = https://rpm.mariadb.org/10.11/rhel/$releasever/$basearch' >> /etc/yum.repos.d/mariadb.repo
echo 'baseurl = https://mirror.23m.com/mariadb/yum/10.11/rhel/$releasever/$basearch' >> /etc/yum.repos.d/mariadb.repo
echo 'module_hotfixes = 1' >> /etc/yum.repos.d/mariadb.repo
echo '# gpgkey = https://rpm.mariadb.org/RPM-GPG-KEY-MariaDB' >> /etc/yum.repos.d/mariadb.repo
echo 'gpgkey = https://mirror.23m.com/mariadb/yum/RPM-GPG-KEY-MariaDB' >> /etc/yum.repos.d/mariadb.repo
echo 'gpgcheck = 1


systemctl enable mariadb

systemctl start mariadb

systemctl status mariadb

