#!/bin/bash 

# Fichier de configuration créé dans le but d'automatiser la mise en place de rsync

echo "Installation de rsync"
echo "-------------------------"
echo ""

# Installation de rsync

dnf -y install rsync

# Configuration de rsync

# Création du script de sauvegarde


#touch /etc/backup.sh
#echo "#!/bin/bash" > /etc/backup.sh
#echo "" >> /etc/backup.sh
#echo "# Script de sauvegarde" >> /etc/backup.sh
#echo "" >> /etc/backup.sh
touch /sbin/test.sh
echo '#!/bin/bash' > /sbin/test.sh
echo '' >> /sbin/test.sh
echo '# Script de sauvegarde' >> /sbin/test.sh
echo '' >> /sbin/test.sh
#mkdir /backup/etc
#mkdir /backup/var
#mkfir /backup/srv
#mkdir /backup/home
mkdir /home/admin/backup
mkdir /home/admin/backup/etc
mkdir /home/admin/backup/var
mkdir /home/admin/backup/srv


#echo 'rsync -avz --delete /etc/ /backup/etc/"$(date +%Y-%m-%d)_etc"' >> /etc/backup.sh
#echo 'rsync -avz --delete /var/ /backup/var/"$(date +%Y-%m-%d)_var"' >> /etc/backup.sh
#echo 'rsync -avz --delete /srv/ /backup/etc/"$(date +%Y-%m-%d)_srv"' >> /etc/backup.sh
#echo 'rsync -avz --delete /home/ /backup/home/"$(date +%Y-%m-%d)_home"' >> /etc/backup.sh
echo 'rsync -avz --delete /etc/ /home/admin/backup/etc/"$(date +%Y-%m-%d)_etc"' >> /sbin/test.sh
echo 'rsync -avz --delete /var/ /home/admin/backup/var/"$(date +%Y-%m-%d)_var"' >> /sbin/test.sh
echo 'rsync -avz --delete /srv/ /home/admin/backup/etc/"$(date +%Y-%m-%d)_srv"' >> /sbin/test.sh

#chmod +x /backup/backup.sh
chmod +x /sbin/test.sh

# Création de la tâche cron

#bash -c "(crontab -l 2>/dev/null; echo '0 12 * * * /backup/backup.sh') | crontab -"
bash -c "(crontab -l 2>/dev/null; echo '0 12 * * * /sbin/test.sh') | crontab -"
echo "Configuration de rsync terminée."
echo "-------------------------"
echo ""



