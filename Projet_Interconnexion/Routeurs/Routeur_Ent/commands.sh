#!/bin/bash


echo 1 > /proc/sys/net/ipv4/ip_forward 


ip route add 120.0.168.0/21 via 120.0.176.14 
ip route add 120.0.160.0/21 via 120.0.176.13


tail -f /dev/null