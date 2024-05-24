#!/bin/bash
echo -e "\nConfiguration de MySQL"
echo -e "----------------------\n"

sudo systemctl enable mysqld
sudo systemctl start mysqld

mysql -e "SHOW DATABASES;" -p

echo -e "\nConfiguration de MySQL terminée"
echo -e "-------------------------------\n"