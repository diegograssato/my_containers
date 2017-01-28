####################################
# DTuX PHP 7.1 /  image         #
####################################
FROM debian:jessie

MAINTAINER Diego Pereira Grassato <diego.grassato@gmail.com>

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d && \
    echo "deb http://httpredir.debian.org/debian jessie main contrib non-free"  > /etc/apt/sources.list && \
    echo "deb http://httpredir.debian.org/debian jessie-updates main contrib non-free"  >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ jessie/updates main contrib non-free"  >> /etc/apt/sources.list && \
    DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget locales apt-transport-https ca-certificates && \
    echo "deb https://packages.sury.org/php/ jessie main" >> /etc/apt/sources.list.d/php.list && \
    curl -sS https://packages.sury.org/php/apt.gpg | apt-key add -


RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive  apt-get -y --no-install-recommends install \
    php7.1 php7.1-cli php7.1-curl php7.1-xsl php7.1-xml php7.1-xmlrpc php7.1-readline php7.1-json \
    php7.1-imagick php7.1-imap php7.1-intl php7.1-pspell php7.1-recode php7.1-mbstring \
    php7.1-bz2 php7.1-zip php7.1-enchant php7.1-gd php7.1-geoip php7.1-gmp php7.1-igbinary php7.1-mcrypt \
    php7.1-apcu php7.1-apcu-bc php7.1-redis php7.1-memcached php7.1-memcache php7.1-msgpack php7.1-opcache \
    php7.1-pgsql php7.1-sqlite3 php7.1-mongodb php7.1-mysql php7.1-ldap php-pear mcrypt libsasl2-dev \
    php-uploadprogress php-uuid php-radius php-amqp php-ssh2 php-yaml php-zmq \
    php7.1-dev php7.1-fpm php7.1-bcmath php7.1-xdebug git build-essential make libgss3 g++ && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

#COPY msodbcsql-13.0.0.0.tar.gz /tmp
#COPY zend /usr/local/zend
#RUN mv /usr/local/zend/lib/libZendDevBarLib.so /usr/lib/ && \
# RUN cd /tmp &&  tar -zxf msodbcsql-13.0.0.0.tar.gz  && \
#     cd /tmp && cd msodbcsql-13.0.0.0  && bash ./install.sh install --force --accept-license  && \
#     cd /tmp && rm -rf msodbcsql-13.0.0.0 && rm msodbcsql-13.0.0.0.tar.gz && rm -rf pear
# unixodbc-dev unixodbc odbcinst
#RUN pecl channel-update pecl.php.net && pecl install sqlsrv-4.0.6 pdo_sqlsrv-4.0.6
RUN git clone https://github.com/Yaoguais/phpng-xhprof.git /tmp/php-src/ext/xhprof && \
    cd /tmp/php-src/ext/xhprof && \
    phpize && \
    ./configure --with-php-config=/usr/bin/php-config7.1 && \
    make && make install && \
    rm -rf /tmp/php-src
COPY config/php/xdebug.ini /etc/php/7.1/mods-available/xdebug.ini
COPY config/php/xhprof.ini /etc/php/7.1/mods-available/xhprof.ini
COPY config/php/opcache.ini /etc/php/7.1/mods-available/opcache.ini
COPY config/php/sqlsrv.ini /etc/php/7.1/mods-available/sqlsrv.ini
COPY config/php/www.conf /etc/php/7.1/fpm/pool.d/www.conf

# Ensure UTF-8
ENV LC_ALL          C.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8
ENV ZEND_MODULES_PATH /usr/local/zend
ENV PHP_BASE "/etc/php/7.1"

RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    apt-get remove vim wget curl gcc-4.8-base libapache2-mod-php7.1 unixodbc-dev g++ build-essential make php7.1-dev --purge -y && \
    apt-get purge -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/

WORKDIR /var/www/html

# Copy configs and scripts
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN mkdir -p /run/php && mkdir -p /var/www/html && chmod 777 /run/php && chmod 777 /bin/docker-entrypoint.sh

# Starter script
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
# Starter script
CMD ["php", "-a"]
