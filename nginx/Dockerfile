FROM alpine:3.3

MAINTAINER Diego Perera Grassato <diego.grassato@gmail.com>

RUN apk add --update nginx openssl bash && rm -rf /var/cache/apk/*
RUN mkdir /tmp/nginx && \
    mkdir -p /etc/nginx/sites-enabled && \
    mkdir -p /etc/nginx/sites-available && \
    mkdir -p /etc/nginx/ssl && \
    chmod 777 -R /var/lib/nginx

COPY config/*.conf /etc/nginx/sites-available/
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY config/index.* /var/www/
RUN chmod 777 /docker-entrypoint.sh

WORKDIR /var/www/

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/nginx"]
