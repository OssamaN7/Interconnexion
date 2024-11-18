#!/bin/bash
 


ip route add 120.0.160.0/21 via 120.0.168.4
ip route add 120.0.176.0/21 via 120.0.168.4

tail -f /dev/null
