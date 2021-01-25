#!/bin/sh

refresh_config_cmd="./refresh_configs.sh"
nginx_config_available_path="/etc/nginx/conf.d/sites-available"

crond
sh -c "sleep 10 && $refresh_config_cmd" &
sh -c "while inotifywait -re create,delete,move,modify $nginx_config_available_path; do cd /home/nginx; $refresh_config_cmd; done" &

nginx -g "daemon off;"
