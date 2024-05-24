#!/bin/bash
echo -e "\nConfiguration du NFS"
echo -e "--------------------\n"

source ../config.cfg

# Création d'un utilisateur NFS
useradd -u $UIDNFS $NFSUSERNAME

# Changement du nom de domaine 
sed -i '5s/^#//' /etc/idmapd.conf 
sed -i "5s/.*/Domain = $NAMESERVER.$DOMAIN/" /etc/idmapd.conf 

# Création de l'emplacement du partage NFS
# Partage public - tout le monde peut écrire, lire et exécuter 
# sans accès au root. Les dossiers se trouvent dans la partition /srv du serveur
# -> partition à part pour les données du serveur.
mkdir -p /srv/nfs/public 
chmod 777 /srv/nfs/public
chmod +t /srv/nfs/public
chown nobody:nobody /srv/nfs/public

# Partage privé - seuls ceux ayant accès au dossier peuvent écrire, 
# lire et exécuter sans accès au compte root.
mkdir -p /srv/nfs/private
chown $NFSUSERNAME:$NFSUSERNAME /srv/nfs/private
chmod 777 /srv/nfs/private

# Configuration du fichier /etc/exports (configuration ainsi que de la sécurisation)
echo "/srv/nfs/public *(rw,async,root_squash,anonuid=65534,anongid=65534,secure,no_subtree_check)" | tee -a /etc/exports
echo "/srv/nfs/private $IPCLIENT(rw,async,all_squash,secure,no_subtree_check,anonuid=$UIDNFS,anongid=$GIDNFS)" | tee -a /etc/exports

# Activation du serveur NFS au démarrage
systemctl enable nfs-server
systemctl start nfs-server

echo -e "\nConfiguration du NFS terminée"
echo -e "-----------------------------\n"



