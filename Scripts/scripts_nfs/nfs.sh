#!/bin/bash
source ../config.cfg

# Création d'un utilisateur NFS
sudo useradd -u $UIDNFS $NFSUSERNAME

# Changement du nom de domaine 
sudo sed -i '5s/^#//' /etc/idmapd.conf 
sudo sed -i "5s/.*/Domain = $NAMESERVER.$DOMAIN/" /etc/idmapd.conf 

# Création de l'emplacement du partage NFS
# Partage public - tout le monde peut écrire, lire et exécuter 
# sans accès au root. Les dossiers se trouvent dans la partition /srv du serveur
# -> partition à part pour les données du serveur.
sudo mkdir -p /srv/nfs/public 
sudo chmod 777 /srv/nfs/public
sudo chmod +t /srv/nfs/public
sudo chown nobody:nobody /srv/nfs/public

# Partage privé - seuls ceux ayant accès au dossier peuvent écrire, 
# lire et exécuter sans accès au compte root.
sudo mkdir -p /srv/nfs/private
sudo chown $NFSUSERNAME:$NFSUSERNAME /srv/nfs/private
sudo chmod 777 /srv/nfs/private

# Configuration du fichier /etc/exports (configuration ainsi que de la sécurisation)
sudo echo "/srv/nfs/public *(rw,async,root_squash,anonuid=65534,anongid=65534,secure,no_subtree_check)" | sudo tee -a /etc/exports
sudo echo "/srv/nfs/private $IPCLIENT(rw,async,all_squash,secure,no_subtree_check,anonuid=$UIDNFS,anongid=$GIDNFS)" | sudo tee -a /etc/exports

# Activation du serveur NFS au démarrage
sudo systemctl enable nfs-server
sudo systemctl start nfs-server

