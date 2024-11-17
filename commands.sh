#!/bin/bash
sudo su
echo 1 > /proc/sys/net/ipv4/ip_forward
echo -e "\033[0;31mBonjour je suis la machine4\033[0m"
tail -f /dev/null

