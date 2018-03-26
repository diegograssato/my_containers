FROM alpine:latest

MAINTAINER Diego Perera Grassato <diego.grassato@gmail.com>

RUN apk add --update openssl bash jq freeradius freeradius-mysql \
    freeradius-radclient freeradius-redis freeradius-ldap bash
    #rm -rf /var/cache/apk/*
 

# COPY config/*.conf /etc/nginx/sites-available/
# COPY docker-entrypoint.sh /docker-entrypoint.sh
# COPY config/index.* /var/www/
# RUN chmod 777 /docker-entrypoint.sh
# Until heartbleed patch makes it into repo, ignore checking
RUN sed -i 's/allow_vulnerable_openssl.*/allow_vulnerable_openssl = yes/g' \
    /etc/raddb/radiusd.conf

ADD ./src/clients.conf /etc/raddb/clients.conf
ADD ./src/users /etc/raddb/users

#ADD ./src/default /etc/raddb/sites-available/default
#ADD ./src/inner-tunnel /etc/raddb/sites-available/inner-tunnel

WORKDIR /etc/raddb
EXPOSE 1812
EXPOSE 1813
EXPOSE 1814
EXPOSE 18120

#ENTRYPOINT ["/docker-entrypoint.sh"]

CMD radiusd -X
