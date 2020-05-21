#!/bin/sh

crond
sh -c 'sleep 1 && ./update_ssl.sh' &

nginx -g 'daemon off;'
