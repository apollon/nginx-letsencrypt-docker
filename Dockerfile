FROM nginx:mainline-alpine

RUN apk --no-cache add openssl && \
	mkdir -p /etc/nginx/ssl && \
	openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048 \
	apk del openssl

RUN apk --no-cache add certbot-nginx inotify-tools

WORKDIR /etc/nginx/conf.d

RUN rm -rf *.conf
COPY ./general.conf ./ssl-params.props ./

RUN mkdir -p /home/nginx
WORKDIR /home/nginx

COPY ./entrypoint.sh ./update_ssl.sh ./renew_cert.sh ./
RUN chmod +x *.sh

RUN echo "0 5 * * 1 /home/nginx/renew_cert.sh" | crontab -

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log
RUN mkdir -p /var/log/letsencrypt \ 
	&& touch /var/log/letsencrypt/letsencrypt.log \
	&& ln -sf /dev/stdout /var/log/letsencrypt/letsencrypt.log

EXPOSE 80 443

CMD [ "sh", "./entrypoint.sh"]
