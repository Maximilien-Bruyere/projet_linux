#!/bin/bash
echo -e "\nConfiguration de CLAMAV"
echo -e "-----------------------\n"

mkdir /var/log/clamav
touch /var/log/clamav/clamav-scan.log
bash -c "(crontab -l 2>/dev/null; echo '30 12 * * * /usr/bin/clamscan -ri / >> /var/log/clamav/clamav-scan.log') | crontab -"
bash -c "(crontab -l 2>/dev/null; echo '0 12 3 * * freshclam') | crontab -"

echo -e "\nConfiguration de CLAMAV terminée"
echo -e "--------------------------------\n"