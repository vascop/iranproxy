#!/usr/bin/env bash

doctl compute droplet delete iranproxy -f
doctl compute floating-ip delete -f `cat floating_ip.txt`

echo "Remove old files: floating_ip.txt, instance_info.txt"