#!/bin/sh

crond
sh -c 'sleep 10 && ./refresh_configs.sh' &
sh -c 'while inotifywait -re create,delete,move,modify /etc/nginx/conf.d/sites-available/; do cd /home/nginx; ./refresh_configs.sh; done' &

nginx -g 'daemon off;'
