# Run an Signal's simple TLS proxy easily on digital ocean

1. Buy a domain name and setup a digitalocean account
2. Install `doctl`
3. Run `./launch.sh` to launch a new instance and set it up with Signal's simple TLS proxy.
4. Run `./setup.sh` on the instance to setup the proxy

Some of these might not work out of the box as this was just thrown together quickly. 


	doctl compute droplet create \
		# doctl compute region list
		--region ams3 \
		# doctl compute image list-distribution
		--image ubuntu-20-10-x64 \
		# doctl compute size list
		--size s-1vcpu-2gb \
		--enable-backups \
		--enable-monitoring \
		# doctl compute ssh-key list
		--ssh-keys digitalocearn \
		--tag-name iranproxy \
		--user-data-file bootstrap.sh \
		--wait \
		iranproxy
