#!/usr/bin/env bash

DOMAIN="MYDOMAINNAME"

signal_proxy_dir="/root/$1"

sudo apt update
sudo apt install -y docker docker-compose git
git clone https://github.com/signalapp/Signal-TLS-Proxy.git $signal_proxy_dir
cd $signal_proxy_dir

data_path="./data/certbot"

if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
  echo
fi

docker-compose run -p 80:80 --rm --entrypoint "\
  sh -c \"certbot certonly --standalone \
    --register-unsafely-without-email \
    -d $DOMAIN \
    --agree-tos \
    --force-renewal && \
    ln -fs /etc/letsencrypt/live/$DOMAIN/ /etc/letsencrypt/active\"" certbot
echo
