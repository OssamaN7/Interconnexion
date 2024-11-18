#!/bin/bash
sudo su
#ip route add 120.0.168.0/21 via 120.0.176.X via ethX
echo 1 > /proc/sys/net/ipv4/ip_forward
echo -e "\033[0;31mBonjour je suis Routeur Services\033[0m"
tail -f /dev/null

