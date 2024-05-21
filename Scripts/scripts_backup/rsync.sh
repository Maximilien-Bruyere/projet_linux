#!/bin/bash 

# Fichier de configuration créé dans le but d'automatiser la mise en place de rsync

echo "Installation de rsync"
echo "-------------------------"
echo ""

# Installation de rsync

dnf -y install rsync

# Configuration de rsync

# Création du script de sauvegarde

#mkdir /backup
#touch /backup/backup.sh
touch /etc/backup.sh
echo "#!/bin/bash" > /etc/backup.sh
echo "" >> /etc/backup.sh
echo "# Script de sauvegarde" >> /etc/backup.sh
echo "" >> /etc/backup.sh
# echo "rsync -av --delete /web /backup/" >> /backup/backup.sh
# rsync -avz --delete /srv/ admin@192.168.1.170:/backup/srv >> /etc/backup.sh
# rsync -avz --delete /var/ admin@192.168.1.170:/backup/var >> /etc/backup.sh
# rsync -avz --delete /etc/ admin@192.168.1.170:/backup/etc >> /etc/backup.sh
rsync -avz --delete /etc/ /backup/etc/"$(date +%Y-%m-%d)_etc" >> /etc/backup.sh
rsync -avz --delete /var/ /backup/var/"$(date +%Y-%m-%d)_var" >> /etc/backup.sh
rsync -avz --delete /srv/ /backup/etc/"$(date +%Y-%m-%d)_srv" >> /etc/backup.sh
rsync -avz --delete /home/ /backup/home/"$(date +%Y-%m-%d)_home >> /etc/backup.sh



#rsync -avz --delete /home admin@192.168.1.170:/backup/ >> /etc/backup.sh

chmod +x /backup/backup.sh


# Création de la tâche cron

# echo "0 13 * * * /backup/backup.sh" >> /etc/crontab
bash -c "(crontab -l 2>/dev/null; echo '0 12 * * * /backup/backup.sh') | crontab -"

echo "Configuration de rsync terminée."
echo "-------------------------"
echo ""
