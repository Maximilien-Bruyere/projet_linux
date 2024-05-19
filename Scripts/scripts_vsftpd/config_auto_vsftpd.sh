#!/bin/bash 
# Fichier de configuration créé dans le but d"automatiser
# l"installation de vsftpd sur un serveur.

echo ""
echo "Installation de vsftpd"
echo "----------------------"
echo ""
systemctl start vsftpd
systemctl enable vsftpd

echo ""
echo "Configuration de vsftpd"
echo "------------------------"
echo ""

sed -i '100 s/^#//g' /etc/vsftpd/vsftpd.conf
sed -i '101 s/^#//g' /etc/vsftpd/vsftpd.conf
sed -i '103 s/^#//g' /etc/vsftpd/vsftpd.conf

systemctl restart vsftpd

echo 'local_root=/srv/web/$USER' >> /etc/vsftpd/vsftpd.conf
echo 'user_sub_token=$USER' >> /etc/vsftpd/vsftpd.conf

systemctl restart vsftpd

openssl req -x509 -nodes -newkey rsa:4096 -keyout /etc/pki/tls/certs/vsftpd.pem -out /etc/pki/tls/certs/vsftpd.pem -days 3650

echo 'rsa_cert_file=etc/pki/tls/certs/vsftpd.pem' >> /etc/vsftpd/vsftpd.conf
echo 'ssl_enable=YES' >> /etc/vsftpd/vsftpd.conf
echo 'force_local_data_ssl=YES' >> /etc/vsftpd/vsftpd.conf
echo 'force_local_logins_ssl=YES' >> /etc/vsftpd/vsftpd.conf
echo 'rsa_private_key_file=/etc/pki/tls/certs/vsftpd.pem' >> /etc/vsftpd/vsftpd.conf
echo 'ssl_tlsv1=YES' >> /etc/vsftpd/vsftpd.conf
echo 'allow_anon_ssl=NO' >> /etc/vsftpd/vsftpd.conf
echo 'pasv_enable=YES' >> /etc/vsftpd/vsftpd.conf
echo 'pasv_min_port=60000' >> /etc/vsftpd/vsftpd.conf
echo 'pasv_max_port=61000' >> /etc/vsftpd/vsftpd.conf

systemctl restart vsftpd