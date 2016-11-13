####################################
# DTuX PHP 7.0 /  image         #
####################################
FROM debian:jessie

MAINTAINER Diego Pereira Grassato <diego.grassato@gmail.com>

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d && \
    sed -i 's/main/main contrib non-free/' /etc/apt/sources.list && \
    DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget locales && \
    echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && \
    curl -sS https://www.dotdeb.org/dotdeb.gpg | apt-key add -

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive  apt-get -y --no-install-recommends install \
    php7.0 php7.0-cli php7.0-curl php7.0-xsl php7.0-xml php7.0-xmlrpc php7.0-readline php7.0-json \
    php7.0-imagick php7.0-imap php7.0-intl php7.0-msgpack php7.0-pspell php7.0-recode php7.0-mbstring \
    php7.0-bz2 php7.0-zip php7.0-enchant php7.0-gd php7.0-geoip php7.0-gmp php7.0-igbinary php7.0-mcrypt \
    php7.0-apcu php7.0-apcu-bc php7.0-redis php7.0-memcached php7.0-opcache php7.0-xdebug \
    php7.0-pgsql php7.0-sybase php7.0-sqlite3 php7.0-mongodb php7.0-mysql php7.0-ldap php-pear mcrypt libsasl2-dev && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Ensure UTF-8
ENV LC_ALL          C.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    apt-get remove wget curl gcc-4.8-base --purge -y && \
    apt-get purge -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/

WORKDIR /var/www

# Starter script
CMD ["php", "-a"]
