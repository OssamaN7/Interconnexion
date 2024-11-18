#!/bin/bash
sudo su 
ip route add 120.0.168.0/21 via 120.0.160.4 dev eth0
ip route add 120.0.176.0/21 via 120.0.160.4 dev eth0
systemctl enable bind9
tail -f /dev/null
