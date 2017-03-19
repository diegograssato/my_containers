####################################
# DTuX PHP 7.1 /  image         #
####################################
FROM php:7.1.0-fpm-alpine

MAINTAINER Diego Pereira Grassato <diego.grassato@gmail.com>

# Ensure UTF-8
ENV LC_ALL          C.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8

RUN apk add --update freetds freetype icu libintl libldap libjpeg libmcrypt libpng libpq \
                      libwebp build-base imagemagick-dev pcre-dev wget libmemcached-dev


RUN apk add --update freetds-dev \
    freetype-dev \
    gettext-dev \
    icu-dev \
    jpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libwebp-dev \
    libxml2-dev \
    autoconf \
    g++ \
    libtool \
    make \
    zlib-dev \
    cyrus-sasl-dev \
    git \
    gmp \
    gmp-dev \
    libpq \
    postgresql-dev

RUN docker-php-source extract \
    && apk add --no-cache --virtual .phpize-deps-configure $PHPIZE_DEPS \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && apk del .phpize-deps-configure
# Configure extensions
RUN docker-php-ext-configure gd --with-jpeg-dir=usr/ --with-freetype-dir=usr/ --with-webp-dir=usr/
RUN docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" gd
RUN docker-php-ext-configure pdo_dblib --with-libdir=lib/
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

RUN docker-php-ext-install \
    exif \
    gettext \
    intl \
    pdo_dblib \
    pdo_mysql \
    pgsql \
    pdo_pgsql \
    mysqli \
    opcache \
    pcntl \
    xmlrpc \
    zip \
    calendar \
    bcmath \
    ctype \
    gmp \
    soap \
    iconv \
    mcrypt

#Memcached
RUN set -xe \
    &&   git clone -b php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
    && docker-php-ext-configure /usr/src/php/ext/memcached \
        --disable-memcached-sasl \
    && docker-php-ext-install /usr/src/php/ext/memcached \
    && rm -rf /usr/src/php/ext/memcached

#Xdebug
RUN set -xe \
    && pecl install redis-3.1.0 \
    && pecl install imagick \
    && pecl install xdebug-2.5.0 \
    && docker-php-ext-enable redis xdebug imagick

RUN apk del freetds-dev \
    freetype-dev \
    gettext-dev \
    icu-dev \
    jpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libwebp-dev \
    libxml2-dev \
    libtool \
    zlib-dev \
    cyrus-sasl-dev \
    git \
    && rm -rf /var/cache/apk/*

# Expose ports
EXPOSE 9000
EXPOSE 9004

COPY php/* /usr/local/etc/php/conf.d/

WORKDIR /var/www/html

# Copy configs and scripts
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN mkdir -p /run/php && mkdir -p /var/www/html && chmod 777 /run/php && chmod 777 /bin/docker-entrypoint.sh

# Starter script
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
# Starter script
CMD ["php-fpm", "-F"]
