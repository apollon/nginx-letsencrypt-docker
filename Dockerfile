FROM nginx:mainline-alpine

RUN apk --no-cache add openssl && \
	mkdir -p /etc/nginx/ssl && \
	openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048 \
	apk del openssl

RUN apk --no-cache add certbot-nginx inotify-tools

RUN echo "0 5 * * 1 /home/nginx/refresh_configs.sh" | crontab -

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log
RUN mkdir -p /var/log/letsencrypt \ 
	&& touch /var/log/letsencrypt/letsencrypt.log \
	&& ln -sf /dev/stdout /var/log/letsencrypt/letsencrypt.log

EXPOSE 80 443

WORKDIR /etc/nginx/conf.d

RUN rm -rf *.conf
COPY ./configs/general.conf ./configs/ssl-params.props ./

RUN mkdir -p ./sites-enabled ./sites-available
RUN mkdir -p /var/www/certbot

RUN mkdir -p /home/nginx
WORKDIR /home/nginx

COPY ./scripts/entrypoint.sh ./scripts/refresh_configs.sh ./scripts/renew_cert.sh ./
RUN chmod +x *.sh

CMD [ "sh", "./entrypoint.sh" ]
