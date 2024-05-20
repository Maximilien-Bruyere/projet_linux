#!/bin/bash 

# Fichier de configuration créé dans le but d'automatiser la mise en place de rsync

echo "Installation de rsync"
echo "-------------------------"
echo ""

# Installation de rsync

dnf -y install rsync

# Configuration de rsync

# Création du script de sauvegarde

touch /backup/backup.sh
echo "#!/bin/bash" > /backup/backup.sh
echo "" >> /backup/backup.sh
echo "# Script de sauvegarde" >> /backup/backup.sh
echo "" >> /backup/backup.sh
echo "rsync -av --delete /web /backup/" >> /backup/backup.sh
chmod +x /backup/backup.sh


# Création de la tâche cron

 echo "0 13 * * * /backup/backup.sh" >> /etc/crontab

echo "Configuration de rsync terminée."
echo "-------------------------"
echo ""
