#!/bin/bash 
echo -e "\nConfiguration de VSFTPD"
echo -e "-----------------------\n"

source ../config.cfg

systemctl start vsftpd
systemctl enable vsftpd

sed -i '100 s/^#//g' /etc/vsftpd/vsftpd.conf
sed -i '101 s/^#//g' /etc/vsftpd/vsftpd.conf
sed -i '103 s/^#//g' /etc/vsftpd/vsftpd.conf

systemctl restart vsftpd

echo 'local_root=/srv/web/$USER' >> /etc/vsftpd/vsftpd.conf
echo 'user_sub_token=$USER' >> /etc/vsftpd/vsftpd.conf

systemctl restart vsftpd

echo 'rsa_cert_file=etc/pki/tls/certs/vsftpd.pem' >> /etc/vsftpd/vsftpd.conf
echo 'ssl_enable=YES' >> /etc/vsftpd/vsftpd.conf
echo 'force_local_data_ssl=YES' >> /etc/vsftpd/vsftpd.conf
echo 'force_local_logins_ssl=YES' >> /etc/vsftpd/vsftpd.conf
echo 'ssl_tlsv1=YES' >> /etc/vsftpd/vsftpd.conf
echo 'allow_anon_ssl=NO' >> /etc/vsftpd/vsftpd.conf
echo 'pasv_enable=YES' >> /etc/vsftpd/vsftpd.conf
echo 'pasv_min_port=60000' >> /etc/vsftpd/vsftpd.conf
echo 'pasv_max_port=61000' >> /etc/vsftpd/vsftpd.conf
echo 'allow_writeable_chroot=YES' >> /etc/vsftpd/vsftpd.conf

touch /etc/vsftpd/chroot_list

systemctl restart vsftpd

setsebool -P ftpd_full_access on

# Création du répertoire pour l'utilisateur principal
mkdir -p /srv/web/$PRIMARYUSER
chown $PRIMARYUSER:$PRIMARYUSER /srv/web/$PRIMARYUSER
chmod 755 /srv/web/$PRIMARYUSER

echo -e "\nConfiguration de VSFTPD terminée"
echo -e "--------------------------------\n"