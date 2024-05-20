#!/bin/bash 

# Fichier de configuration créé dans le but d"automatiser
# l"installation de vsftpd sur un serveur.

source ../config.cfg

echo ""
echo "Configuration de VSFTPD"
echo "------------------------"
echo ""

sudo systemctl start vsftpd
sudo systemctl enable vsftpd

sudo sed -i '100 s/^#//g' /etc/vsftpd/vsftpd.conf
sudo sed -i '101 s/^#//g' /etc/vsftpd/vsftpd.conf
sudo sed -i '103 s/^#//g' /etc/vsftpd/vsftpd.conf

sudo systemctl restart vsftpd

sudo echo 'local_root=/srv/ftp/$USER' >> /etc/vsftpd/vsftpd.conf
sudo echo 'user_sub_token=$USER' >> /etc/vsftpd/vsftpd.conf

sudo systemctl restart vsftpd

sudo openssl req -x509 -nodes -newkey rsa:4096 -keyout /etc/pki/tls/certs/vsftpd.pem -out /etc/pki/tls/certs/vsftpd.pem -days 3650

sudo echo 'rsa_cert_file=etc/pki/tls/certs/vsftpd.pem' >> /etc/vsftpd/vsftpd.conf
sudo echo 'ssl_enable=YES' >> /etc/vsftpd/vsftpd.conf
sudo echo 'force_local_data_ssl=YES' >> /etc/vsftpd/vsftpd.conf
sudo echo 'force_local_logins_ssl=YES' >> /etc/vsftpd/vsftpd.conf
sudo echo 'rsa_private_key_file=/etc/pki/tls/certs/vsftpd.pem' >> /etc/vsftpd/vsftpd.conf
sudo echo 'ssl_tlsv1=YES' >> /etc/vsftpd/vsftpd.conf
sudo echo 'allow_anon_ssl=NO' >> /etc/vsftpd/vsftpd.conf
sudo echo 'pasv_enable=YES' >> /etc/vsftpd/vsftpd.conf
sudo echo 'pasv_min_port=60000' >> /etc/vsftpd/vsftpd.conf
sudo echo 'pasv_max_port=61000' >> /etc/vsftpd/vsftpd.conf

sudo systemctl restart vsftpd

# Ajouter les lignes suivantes à /etc/skel/.bash_profile
echo 'if [ ! -d /srv/ftp/$USER ]; then' | sudo tee -a /etc/skel/.bash_profile
echo '    sudo mkdir -p /srv/ftp/$USER' | sudo tee -a /etc/skel/.bash_profile
echo '    sudo chown $USER:$USER /srv/ftp/$USER' | sudo tee -a /etc/skel/.bash_profile
echo 'fi' | sudo tee -a /etc/skel/.bash_profile

# Création du répertoire pour l'utilisateur principal
sudo mkdir -p /srv/web/$PRIMARYUSER
sudo useradd -d /srv/web/$PRIMARYUSER -s /sbin/nologin $PRIMARYUSER
sudo chown $PRIMARYUSER:$PRIMARYUSER /srv/web/$PRIMARYUSER
sudo chmod 700 /srv/web/$PRIMARYUSER