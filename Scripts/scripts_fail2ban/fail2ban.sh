#!/bin/bash
echo -e "\nConfiguration de fail2ban"
echo -e "-------------------------\n"

systemctl start fail2ban
systemctl enable fail2ban
systemctl status fail2ban

cd /etc/fail2ban
echo "[DEFAULT]" > jail.local
echo "bantime = 120" >> jail.local
echo "maxretry = 3 " >> jail.local
echo "[sshd] = true " >> jail.local
echo "enabled = true" >> jail.local

fail2ban-client status
systemctl restart fail2ban

echo -e "\nConfiguration de fail2ban terminée"
echo -e "----------------------------------\n"