#!/bin/bash

# Répertoire source
SOURCE="/chemin/vers/votre/répertoire"

# Répertoire de destination
DESTINATION="/chemin/vers/la/sauvegarde"

# Créer un horodatage
TIMESTAMP=$(date +"%F")

# Nom du fichier de sauvegarde
BACKUPFILE="backup_scripts-$TIMESTAMP"

# Options rsync
OPTIONS="-avh --delete"

# Exécute la commande rsync
rsync $OPTIONS $SOURCE $DESTINATION/$BACKUPFILE

# Vérifie si rsync a réussi
if [ "$?" -eq "0" ]
then
  echo "La sauvegarde a réussi !"
else
  echo "La sauvegarde a échoué."
fi

# Utilisation de crontab pour l'exécution automatique