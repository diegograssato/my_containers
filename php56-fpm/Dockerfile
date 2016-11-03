####################################
# DTuX PHP 5.6 / FPM image         #
####################################
FROM diegograssato/php56

MAINTAINER Diego Pereira Grassato <diego.grassato@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive  apt-get -y --no-install-recommends install \
    php5-dev php5-fpm php5-xcache php5-xdebug php5-uprofiler php5-xhprof
## PHP settings
#
COPY config/php/xdebug.ini /etc/php5/mods-available/xdebug.ini
# COPY config/php/xhprof.ini /etc/php/7.0/mods-available/xhprof.ini
COPY config/php/opcache.ini /etc/php5/mods-available/opcache.ini
COPY config/php/uprofiler.ini /etc/php5/mods-available/uprofiler.ini
COPY config/php/www.conf /etc/php5/fpm/pool.d/www.conf
# RUN ln -s /etc/php/7.0/mods-available/xhprof.ini /etc/php/7.0/fpm/conf.d/20-xhprof.ini
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    apt-get purge -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/

RUN php5dismod opcache xcache
# Copy configs and scripts
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN mkdir -p /run/php && mkdir -p /var/www/html && chmod 777 /run/php && chmod 777 /bin/docker-entrypoint.sh

WORKDIR /var/www

# Starter script
ENTRYPOINT ["/bin/docker-entrypoint.sh"]

CMD ["/usr/sbin/php5-fpm", "-F"]
