#!/bin/bash 

# Fichier de configuration créé dans le but d'automatiser la mise en place de rsync

echo "Installation de rsync"
echo "-------------------------"
echo ""

# Installation de rsync

dnf -y install rsync

# Configuration de rsync

touch /sbin/test.sh
echo '#!/bin/bash' > /sbin/test.sh
echo '' >> /sbin/test.sh
echo '# Script de sauvegarde' >> /sbin/test.sh
echo '' >> /sbin/test.sh

mkdir /home/admin/backup
mkdir /home/admin/backup/etc
mkdir /home/admin/backup/var
mkdir /home/admin/backup/srv

echo 'rsync -avz --delete /etc/ /home/admin/backup/etc/"$(date +%Y-%m-%d)_etc"' >> /sbin/test.sh
echo 'rsync -avz --delete /var/ /home/admin/backup/var/"$(date +%Y-%m-%d)_var"' >> /sbin/test.sh
echo 'rsync -avz --delete /srv/ /home/admin/backup/etc/"$(date +%Y-%m-%d)_srv"' >> /sbin/test.sh

chmod +x /sbin/test.sh

# Création de la tâche cron

bash -c "(crontab -l 2>/dev/null; echo '0 12 * * * /sbin/test.sh') | crontab -"
echo "Configuration de rsync terminée."
echo "-------------------------"
echo ""