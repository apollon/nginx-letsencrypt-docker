FROM nginx:mainline-alpine

RUN apk --no-cache add openssl && \
	apk --no-cache add certbot-nginx
RUN mkdir -p /etc/nginx/ssl && \
	openssl dhparam -out /etc/nginx/ssl/dhparam-2048.pem 2048
RUN apk del openssl

RUN mkdir -p /home/nginx && chown -R nginx:nginx /home/nginx
WORKDIR /home/nginx

RUN rm -rf /etc/nginx/conf.d/*.conf
RUN mkdir -p /var/cache/nginx/push-board

RUN echo "0 5 * * 1 /home/nginx/renew_cert.sh" | crontab -

COPY ./nginx/config/general.conf ./
COPY ./nginx/entrypoint.sh ./nginx/renew_cert.sh ./
RUN chmod +x *.sh

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

#RUN certbot register -n --agree-tos --email apolon11@gmail.com

EXPOSE 80 443

CMD [ "sh", "./entrypoint.sh"]