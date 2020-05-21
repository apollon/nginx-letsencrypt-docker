#!/bin/sh

hostname=${1}
echo "Renew letsencrypt certificate for: ${hostname}"

#rm /etc/nginx/conf.d/push-board.conf
#mv /etc/nginx/conf.d/default.conf.disabled /etc/nginx/conf.d/default.conf
#nginx -s reload

#certbot run --nginx -n --agree-tos --email apolon11@gmail.com -d push-board.lviv.ua
if [ ! -d /etc/letsencrypt/live/${hostname} ]; then
	certbot run --nginx -n --agree-tos --email apolon11@gmail.com -d ${hostname}
else
	certbot renew
fi
#if [ -f /etc/letsencrypt/live/push-board.lviv.ua/fullchain.pem ]; then
#	cd /etc/nginx/conf.d/ && ln -sf /home/nginx/push-board.conf push-board.conf
#else
#	rm -f /etc/nginx/conf.d/push-board.conf
#fi

echo "Reload NGINX"

nginx -t
nginx -s reload