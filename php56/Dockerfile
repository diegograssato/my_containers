####################################
# DTuX PHP 5.6  image         #
####################################
FROM debian:jessie

MAINTAINER Diego Pereira Grassato <diego.grassato@gmail.com>

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d && \
    sed -i 's/main/main contrib non-free/' /etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && apt-get -y --force-yes --no-install-recommends install curl wget
# PHP 5.6 on Debian 8 Jessie (with Zend thread safety), add these two lines instead :
# - https://www.dotdeb.org/instructions/
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list
RUN echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list
RUN wget http://www.dotdeb.org/dotdeb.gpg -O- |apt-key add -

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive  apt-get -y --no-install-recommends install \
    php5 locales  php5-curl php5-xsl php5-xmlrpc php5-readline php5-json \
    php5-imagick php5-imap php5-intl php5-msgpack php5-pspell php5-recode \
    php5-enchant php5-gd php5-geoip php5-gmp php5-igbinary php5-mcrypt \
    php5-redis php5-memcached php5-cli php5-lasso php5-ssh2 \
    php5-pgsql php5-sybase php5-sqlite php5-mongo php5-mysql php5-ldap \
    php-pclzip php-mdb2-driver-mysql php5-msgpack php5-gnupg php-pear mcrypt libsasl2-dev  && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

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

# Ensure UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

WORKDIR /var/www

# Starter script
CMD ["php", "-a"]
