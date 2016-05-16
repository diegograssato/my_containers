####################################
# DTuX PHP 7.0 / FPM image #
####################################
FROM debian:jessie

MAINTAINER Diego Pereira Grassato <diego.grassato@gmail.com>

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d && \
    sed -i 's/main/main contrib non-free/' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y curl && \
    echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && \
    curl -sS https://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
    apt-get update && \
    apt-get -y --no-install-recommends install php7.0-cli php7.0-fpm php7.0-apcu php7.0-apcu-bc php7.0-ldap \
    php7.0-json php7.0-mcrypt php7.0-opcache php7.0-readline  php7.0-memcached php7.0-mongodb php7.0-mysql php7.0-curl \
    php7.0-redis php7.0-sqlite3 php7.0-bz2 php7.0-enchant php7.0-gd php7.0-geoip php7.0-gmp php7.0-igbinary php7.0-xsl \
    php7.0-imagick php7.0-imap php7.0-intl php7.0-msgpack php7.0-pspell php7.0-recode php7.0-xdebug php7.0-xmlrpc && \
    apt-get upgrade -y && \
    apt-get remove wget curl gcc-4.8-base --purge -y && \
    apt-get purge -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/log/* && \
    rm -rf /usr/share/doc/

COPY config/php7/xdebug.ini /etc/php/mods-available/xdebug.ini
COPY config/php7/opcache.ini /etc/php/mods-available/opcache.ini


#COPY config/php7-fpm/application.ini /etc/php/7.0/fpm/conf.d/
#COPY config/php7-fpm/application.ini /etc/php/7.0/cli/conf.d/
COPY config/php7-fpm/application.pool.conf /etc/php/7.0/fpm/pool.d/

# Copy configs and scripts
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN mkdir -p /run/php && mkdir -p /var/www/html && chmod 777 /run/php && chmod 777 /bin/docker-entrypoint.sh

# Starter script
ENTRYPOINT ["/bin/docker-entrypoint.sh"]

CMD ["/usr/sbin/php-fpm7.0", "-F"]
