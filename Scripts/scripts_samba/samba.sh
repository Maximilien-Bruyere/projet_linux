#!/bin/bash
echo -e "\nConfiguration de SAMBA"
echo -e "----------------------\n"

source ../config.cfg

# Configuration globale
echo "- Configuration globale ..."
mv /etc/samba/smb.conf /etc/samba/smb.conf.old
touch /etc/samba/smb.conf
echo "[global]" >> /etc/samba/smb.conf
echo -e "\tworkgroup = WORKGROUP" >> /etc/samba/smb.conf
echo -e "\tserver string = Samba Server %v" >> /etc/samba/smb.conf
echo -e "\tnetbios name = srvlinux" >> /etc/samba/smb.conf
echo -e "\tsecurity = user" >> /etc/samba/smb.conf
echo -e "\tmap to guest = bad user" >> /etc/samba/smb.conf
echo -e "\tdns proxy = yes" >> /etc/samba/smb.conf
echo -e "\tntlm auth = true" >> /etc/samba/smb.conf
echo -e "\thosts allow = $IPADD $IPCLIENT" >> /etc/samba/smb.conf
echo "#" >> /etc/samba/smb.conf

# Création du dossier public
echo "- Configuration du partage public ..."
mkdir -p /srv/samba/public
chmod 777 /srv/samba/public
chown nobody:nobody /srv/samba/public

echo "[public]" >> /etc/samba/smb.conf
echo -e "\tpath = /srv/samba/public" >> /etc/samba/smb.conf
echo -e "\twritable = yes" >> /etc/samba/smb.conf
echo -e "\tguest ok = yes" >> /etc/samba/smb.conf
echo -e "\tguest only = yes" >> /etc/samba/smb.conf
echo -e "\tforce create mode = 777" >> /etc/samba/smb.conf
echo -e "\tforce directory mode = 777" >> /etc/samba/smb.conf
echo "#" >> /etc/samba/smb.conf

# Mis en place du dossier privé pour l'utilisateur principal
echo "[$PRIMARYUSER]" >> /etc/samba/smb.conf
echo -e '\tpath = /srv/web/$USER' >> /etc/samba/smb.conf
echo -e "\twritable = yes" >> /etc/samba/smb.conf
echo -e "\tguest ok = no" >> /etc/samba/smb.conf
echo -e "\tvalid users = $PRIMARYUSER" >> /etc/samba/smb.conf
echo -e "\tinherit permissions = yes " >> /etc/samba/smb.conf

smbpasswd -a $PRIMARYUSER

# SELINUX 
setsebool -P samba_enable_home_dirs on
restorecon -R /srv/samba/public
restorecon -R /srv/web/$PRIMARYUSER

echo "- Redémarrage du service ..."
systemctl enable --now smb

echo -e "\nConfiguration de SAMBA terminée"
echo -e "-------------------------------\n"