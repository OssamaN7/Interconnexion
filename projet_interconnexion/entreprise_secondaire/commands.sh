#!/bin/bash


echo 1 > /proc/sys/net/ipv4/ip_forward 


ip route add 120.0.34.0/24 via 120.0.35.1

tail -f /dev/null
