####################################
# DTuX PHP 7.0 / FPM image         #
####################################
FROM diegograssato/php7

MAINTAINER Diego Pereira Grassato <diego.grassato@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive  apt-get -y --no-install-recommends install \
    php7.0-dev php7.0-fpm php7.0-bcmath php7.0-xdebug git build-essential make || apt-get -f install || true

RUN git clone https://github.com/Yaoguais/phpng-xhprof.git /tmp/php-src/ext/xhprof && \
    cd /tmp/php-src/ext/xhprof && \
    phpize && \
    ./configure --with-php-config=/usr/bin/php-config7.0 && \
    make && make install && \
    rm -rf /tmp/php-src

COPY config/php/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini
COPY config/php/xhprof.ini /etc/php/7.0/mods-available/xhprof.ini
COPY config/php/opcache.ini /etc/php/7.0/mods-available/opcache.ini
COPY config/php/sqlsrv.ini /etc/php/7.0/mods-available/sqlsrv.ini
COPY config/php/www.conf /etc/php/7.0/fpm/pool.d/www.conf
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    apt-get remove git build-essential make  --purge -y && \
    apt-get purge -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/

# Copy configs and scripts
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN mkdir -p /run/php && mkdir -p /var/www/html && chmod 777 /run/php && chmod 777 /bin/docker-entrypoint.sh

WORKDIR /var/www

# Starter script
ENTRYPOINT ["/bin/docker-entrypoint.sh"]

CMD ["/usr/sbin/php-fpm7.0", "-F"]
