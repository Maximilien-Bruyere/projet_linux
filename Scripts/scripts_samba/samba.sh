#!/bin/bash

source ../config.cfg

sudo dnf install -y smb

# Configuration du service SAMBA
echo -e "------------------------------\n"
echo -e "Configuration du service SAMBA\n"

# Configuration globale
echo "- Configuration globale ..."
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.old
sudo touch /etc/samba/smb.conf
sudo echo "[global]" >> /etc/samba/smb.conf
sudo echo -e "\tworkgroup = WORKGROUP"
sudo echo -e "\tserver string = Samba Server %v"
sudo echo -e "\tnetbios name = srvlinux"
sudo echo -e "\tsecurity = user"
sudo echo -e "\tmap to guest = bad user"
sudo echo -e "\tdns proxy = yes"
sudo echo -e "\tntlm auth = true"
sudo echo -e "\thosts allow = $IPADD $IPCLIENT"
sudo echo "#" >> /etc/samba/smb.conf

# Création du dossier public
echo "- Configuration du partage public ..."
sudo mkdir -p /srv/samba/public
sudo chmod 777 /srv/samba/public
sudo chown nobody:nobody /srv/samba/public
sudo echo "[public]" >> /etc/samba/smb.conf
sudo echo -e "\tpath = /srv/samba/public" >> /etc/samba/smb.conf
sudo echo -e "\twritable = yes" >> /etc/samba/smb.conf
sudo echo -e "\tguest ok = yes" >> /etc/samba/smb.conf
sudo echo -e "\tguest only = yes" >> /etc/samba/smb.conf
sudo echo -e "\tforce create mode = 777" >> /etc/samba/smb.conf
sudo echo -e "\tforce directory mode = 777" >> /etc/samba/smb.conf
sudo echo "#" >> /etc/samba/smb.conf

# Création du dossier privé
echo "- Configuration du partage privé ..."
sudo groupadd $SMBGROUPNAME
sudo mkdir -p /srv/samba/private
sudo chgrp $SMBGROUPNAME /srv/samba/private
sudo chmod 770 /srv/samba/private
sudo echo "[private]" >> /etc/samba/smb.conf
sudo echo -e "\tpath = /srv/samba/private" >> /etc/samba/smb.conf
sudo echo -e "\twritable = yes" >> /etc/samba/smb.conf
sudo echo -e "\tguest ok = no" >> /etc/samba/smb.conf
sudo echo -e "\tvalid users = @$SMBGROUPNAME" >> /etc/samba/smb.conf
sudo echo -e "\tforce group = $SMBGROUPNAME" >> /etc/samba/smb.conf
sudo echo -e "\tforce create mode = 770" >> /etc/samba/smb.conf
sudo echo -e "\tinherit permissions = yes " >> /etc/samba/smb.conf
sudo useradd $SMBCLIENT
sudo smbpasswd -a $SMBCLIENT
sudo usermod -aG $SMBGROUPNAME $SMBCLIENT

# SELINUX 
sudo setsebool -P samba_enable_home_dirs on
sudo restorecon -R /srv/samba/public
sudo restorecon -R /srv/samba/private

echo "- Redémarrage ..."
sudo systemctl enable --now smb