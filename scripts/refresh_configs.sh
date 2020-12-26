#!/bin/sh

ssl_cert_path="/etc/letsencrypt/live"
config_available_path="/etc/nginx/conf.d/sites-available"
config_enabled_path="/etc/nginx/conf.d/sites-enabled"
ssl_params_line="include /etc/nginx/conf.d/ssl-params.props;"

rm -rf $config_enabled_path && mkdir -p $config_enabled_path

configs_available=$(find $config_available_path -type f -iname "*.conf")

echo "NGINX configs available: ${configs_available}"

for config in ${configs_available}
do
    server_name=$(cat $config | awk '$1=="server_name"{ for (i=2; i<=NF; i++) { sub(/[\;\,]/, "", $i); print $i } }')

    ./renew_cert.sh ${server_name}
    renew_code=$?
    echo "renew_cert: $renew_code"
    if [ $renew_code -eq 0 ]; then
        dest_config=$(echo $config | sed 's/sites-available/sites-enabled/g')
        echo "dest_config: $dest_config"

        mkdir -p "$(dirname "$dest_config")" && cp "$config" "$dest_config"

        ssl_certificate_params="ssl_certificate $ssl_cert_path/$server_name/fullchain.pem; ssl_certificate_key $ssl_cert_path/$server_name/privkey.pem; ssl_trusted_certificate $ssl_cert_path/$server_name/chain.pem;"

        server_name_line=$(cat $dest_config | awk '$1=="server_name" { print $0 }')

        sed -i "/$server_name_line/a $ssl_params_line $ssl_certificate_params" "$dest_config"
    fi
done

configs_enabled=$(find $config_enabled_path -type f -iname "*.conf")
echo "NGINX configs enabled: ${configs_enabled}"

echo "Reload NGINX"
nginx -t
nginx -s reload
