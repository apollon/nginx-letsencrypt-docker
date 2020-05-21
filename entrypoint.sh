#!/bin/sh

crond
sh -c 'sleep 10 && ./update_ssl.sh' &
sh -c 'while inotifywait -re create,delete,move,modify /etc/nginx/conf.d/sites/; do cd /home/nginx; ./update_ssl.sh; done' &

nginx -g 'daemon off;'
