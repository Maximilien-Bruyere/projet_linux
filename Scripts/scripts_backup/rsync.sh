#!/bin/bash 
echo -e "\nConfiguration de RSYNC"
echo -e "----------------------\n"


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

# Création de la tâche journalière
bash -c "(crontab -l 2>/dev/null; echo '0 12 * * * /sbin/dailybackup.sh') | crontab -"

echo -e "\nConfiguration de RSYNC terminée"
echo -e "-------------------------------\n"
