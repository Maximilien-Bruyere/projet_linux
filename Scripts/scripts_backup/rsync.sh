#!/bin/bash 

# Fichier de configuration créé dans le but d'automatiser la mise en place de rsync

echo "Installation de rsync"
echo "-------------------------"
echo ""

# Installation de rsync

dnf -y install rsync

# Configuration de rsync

touch /sbin/dailybackup.sh
echo '#!/bin/bash' > /sbin/dailybackup.sh
echo '' >> /sbin/dailybackup.sh
echo '# Script de sauvegarde' >> /sbin/dailybackup.sh
echo '' >> /sbin/dailybackup.sh

mkdir /backup/etc
mkdir /backup/var
mkdir /backup/srv
mkdir /backup/home

echo 'rsync -avz --delete /etc/ /backup/etc/"$(date +%Y-%m-%d)_etc"' >> /sbin/dailybackup.sh
echo 'rsync -avz --delete /var/ /backup/var/"$(date +%Y-%m-%d)_var"' >> /sbin/dailybackup.sh
echo 'rsync -avz --delete /srv/ /backup/etc/"$(date +%Y-%m-%d)_srv"' >> /sbin/dailybackup.sh
echo 'rsync -avz --delete /home/ /backup/home/"$(date +%Y-%m-%d)_home"' >> /sbin/dailybackup.sh
chmod +x /sbin/dailybackup.sh

# Création de la tâche cron

bash -c "(crontab -l 2>/dev/null; echo '0 12 * * * /sbin/dailybackup.sh') | crontab -"
echo "Configuration de rsync terminée."
echo "-------------------------"
echo ""