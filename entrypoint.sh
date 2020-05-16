#!/bin/sh

crond
./renew_cert.sh &
nginx -g 'daemon off;'
