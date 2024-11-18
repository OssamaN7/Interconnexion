#!/bin/bash
sudo su

echo 1 > /proc/sys/net/ipv4/ip_forward 


ip route add 120.0.168.0 via 120.0.176.3
