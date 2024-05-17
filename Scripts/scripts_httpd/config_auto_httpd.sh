
systemctl enable httpd
systemctl start httpd

# créer le répertoire web
cd /srv/
mkdir web

# créer un fichier web.conf dans /etc/httpd/conf.d/
cd /etc/httpd/conf.d/
touch web.conf

# ajout de ma config suivante dans le fichier web.conf
echo "<VirtualHost *:80>" >> /etc/httpd/conf.d/web.conf
echo "ServerName www.UwU.lan" >> /etc/httpd/conf.d/web.conf
echo "ServerAlias UwU.lan" >> /etc/httpd/conf.d/web.conf
echo "DocumentRoot /srv/web" >> /etc/httpd/conf.d/web.conf
echo "<Directory /srv/web>" >> /etc/httpd/conf.d/web.conf
echo "Options -Indexes +FollowSymLinks" >> /etc/httpd/conf.d/web.conf
echo "AllowOverride" >> /etc/httpd/conf.d/web.conf
echo "</Directory>" >> /etc/httpd/conf.d/web.conf
echo "ErrorLog /var/log/httpd/UwU.log" >> /etc/httpd/conf.d/web.conf
echo "Customlog /var/log/httpd/UwU_all.log combined" >> /etc/httpd/conf.d/web.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/web.conf

# création d'une page index.html dans /srv/web/
cd /srv/web/
touch index.html
echo "<html>" >> /srv/web/index.html
echo "<body>" >> /srv/web/index.html
echo "<h1> UwU </h1>" >> /srv/web/index.html
echo "</body>" >> /srv/web/index.html
echo "</html>" >> /srv/web/index.html

systemctl restart httpd

apachectl configtest
lynx index.html