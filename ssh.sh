#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <public_ip>"
    exit 1
fi

ssh root@$1 -i ~/.ssh/digitalocean