#!/bin/sh

hostname=${1}
echo "Renew letsencrypt certificate for: ${hostname}"

webroot="/var/www/certbot"
rm -rf $webroot && mkdir -p $webroot

if [ ! -d /etc/letsencrypt/live/${hostname} ]; then
	certbot certonly --webroot -w "$webroot" -n --agree-tos --email apolon11@gmail.com -d ${hostname}
	exit $?
else
	certbot certonly --noninteractive --webroot -w "$webroot" -d ${hostname}
	exit $?
fi
