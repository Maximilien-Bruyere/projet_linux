#!/bin/bash
echo -e "\nConfiguration de CHRONY"
echo -e "-----------------------\n"

source ../config.cfg
timedatectl set-timezone Europe/Brussels
systemctl start chronyd
systemctl enable chronyd
echo "allow $ADDRESS/$MASK" >> /etc/chrony.conf
echo "allow $IPCLIENT" >> /etc/chrony.conf
echo "server $IPADD iburst" >> /etc/chrony.conf

# Ajout des serveurs de temps (BE)
echo "server 0.be.pool.ntp.org iburst" >> /etc/chrony.conf
echo "server 1.be.pool.ntp.org iburst" >> /etc/chrony.conf
echo "server 2.be.pool.ntp.org iburst" >> /etc/chrony.conf
echo "server 3.be.pool.ntp.org iburst" >> /etc/chrony.conf
systemctl restart chronyd
timedatectl set-ntp true

echo -e "\nConfiguration de CHRONY terminée"
echo -e "--------------------------------\n"