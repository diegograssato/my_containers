####################################
# DTuX PHP 7.0 / FPM image         #
####################################
FROM diegograssato/php7

MAINTAINER Diego Pereira Grassato <diego.grassato@gmail.com>


RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive  apt-get -y --no-install-recommends install \
    php7.0-cli php7.0-fpm  php7.0-xdebug

RUN DEBIAN_FRONTEND=noninteractive apt-get purge -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/

COPY config/php7/xdebug.ini /etc/php/mods-available/xdebug.ini
COPY config/php7/opcache.ini /etc/php/mods-available/opcache.ini
COPY config/php7/www.conf /etc/php/7.0/fpm/pool.d/www.conf

# Copy configs and scripts
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN mkdir -p /run/php && mkdir -p /var/www/html && chmod 777 /run/php && chmod 777 /bin/docker-entrypoint.sh

WORKDIR /var/www

# Starter script
ENTRYPOINT ["/bin/docker-entrypoint.sh"]

CMD ["/usr/sbin/php-fpm7.0", "-F"]
