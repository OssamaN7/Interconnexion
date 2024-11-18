#!/bin/bash
sudo su
ip route add 120.0.160.0/21 via 120.0.160.4
ip route add 120.0.176.0/21 via 120.0.160.4

echo 1 > /proc/sys/net/ipv4/ip_forward
echo -e "\033[0;31mBonjour je suis la machine4\033[0m"
tail -f /dev/null
