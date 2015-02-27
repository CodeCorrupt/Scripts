#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
ip route add default via 192.168.2.1 dev wlp9s0 proto static metric 0
