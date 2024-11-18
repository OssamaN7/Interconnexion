#!/bin/bash
sudo su 
#Ajouter les routes
ip route add 120.0.168.0/21 via 120.0.160.4 dev eth0
ip route add 120.0.176.0/21 via 120.0.160.4 dev eth0
service apache2 start
echo -e "\033[0;31mBonjour je suis le serveur WEB\033[0m"
tail -f /dev/null
