#!/bin/sh

servers=$(find /etc/nginx/conf.d/sites -type f -iname "*.conf" -exec awk '$1=="server_name"{ for (i=2; i<=NF; i++) { sub(/[\;\,]/, "", $i); print $i } }' {} + | awk '!NF || !seen[$0]++')

for server in ${servers}
do
    if [[ "${server}" = "_" ]]; then
        continue
    fi
    ./renew_cert.sh ${server}
done
