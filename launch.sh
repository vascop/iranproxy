#!/usr/bin/env bash

ssh_key=~/.ssh/digitalocean

function wait-for-ssh () { 
    until ssh -o ConnectTimeout=2 root@"$1"
        do sleep 1
    done
}

if [ $# -ne 2 ]; then
    echo "Usage: 	$0 <server_name> <domain_name>"
    echo "Example: 	$0 iranproxy ketchup.pizza"
    exit 1
fi

echo "Launching digitalocean server..."
doctl compute droplet create \
	--region ams3 \
	--image ubuntu-20-10-x64 \
	--size s-1vcpu-2gb \
	--enable-backups \
	--enable-monitoring \
	--ssh-keys 745135 \
	--tag-name $1 \
	--wait \
	$1 > instance_info.txt

droplet_id=$(doctl compute droplet get $1 --format ID | tail -n 1)
ip=$(doctl compute floating-ip create --format IP --droplet-id $droplet_id | tail -n 1)
echo $ip > floating_ip.txt

echo "Point your DNS A record for $2 to $ip while we wait for SSH to be available..."
echo "Sleeping 30 seconds..."
sleep 30
echo "Uploading config..."
sed -i s/MYDOMAINNAME/$1/ setup.sh
scp -i $ssh_key setup.sh root@$ip:

echo "Running setup..."
ssh -i $ssh_key '/setup.sh'

echo "To access the server run: ./ssh.sh $ip"
echo "Instance info in instance_info.txt and floating_ip.txt"
echo "After running 'docker-compose up --detach' you can share your proxy as: https://signal.tube/#$DOMAIN"