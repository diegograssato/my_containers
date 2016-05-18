FROM debian:jessie
MAINTAINER Diego Pereira Grassato <diego.grassato@gmail.com>

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
#RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

# Enabling additional repos
RUN sed -i 's/main/main contrib non-free/' /etc/apt/sources.list

ENV SUPPORTED_LANGUAGES="en_US|pt_BR"

# PHP packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes --no-install-recommends install zip unzip git curl wget mc
# PHP 5.6 on Debian 8 Jessie (with Zend thread safety), add these two lines instead :
# - https://www.dotdeb.org/instructions/
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list
RUN echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list
RUN wget http://www.dotdeb.org/dotdeb.gpg -O- |apt-key add -

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes --no-install-recommends install \
    mysql-client openssl ssl-cert openssh-client sudo vim parallel ca-certificates \
    php5-common php5-cli php5-readline php-pear php5-xmlrpc \
    php5-imagick php5-mcrypt php5-curl php5-gd php5-json php5-imap php5-xsl  \
    php5-intl php5-memcache php5-xdebug php5-ssh2 php5-gnupg php5-fpm \
    php5-mysql  php5-mongo  php5-sqlite locales && \
    cat /usr/share/i18n/SUPPORTED | grep -E "$SUPPORTED_LANGUAGES" > /etc/locale.gen && \
    locale-gen

RUN \
    # Create a non-root user with access to sudo and the default group set to 'users' (gid = 100)
    useradd -m -s /bin/bash -g users -u 1000 -G sudo,ssh -p docker docker && \
    echo 'docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

## PHP settings
RUN mkdir -p /var/www/html && \
    # PHP-FPM settings
    ## /etc/php5/fpm/php.ini
    sed -i '/memory_limit = /c memory_limit = 256M' /etc/php5/fpm/php.ini && \
    sed -i '/max_execution_time = /c max_execution_time = 300' /etc/php5/fpm/php.ini && \
    sed -i '/upload_max_filesize = /c upload_max_filesize = 500M' /etc/php5/fpm/php.ini && \
    sed -i '/post_max_size = /c post_max_size = 500M' /etc/php5/fpm/php.ini && \
    sed -i '/error_log = /c error_log = \/dev\/stdout' /etc/php5/fpm/php.ini && \
    sed -i '/;always_populate_raw_post_data/c always_populate_raw_post_data = -1' /etc/php5/fpm/php.ini && \
    sed -i '/;sendmail_path/c sendmail_path = /bin/true' /etc/php5/fpm/php.ini && \
    ## /etc/php5/fpm/php-fpm.conf
    #sed -i '/;daemonize = /c daemonize = no' /etc/php5/fpm/php-fpm.conf && \
    sed -i '/error_log = /c error_log = \/dev\/stdout' /etc/php5/fpm/php-fpm.conf && \
    # PHP CLI settings
    sed -i '/memory_limit = /c memory_limit = 512M' /etc/php5/cli/php.ini && \
    sed -i '/max_execution_time = /c max_execution_time = 600' /etc/php5/cli/php.ini && \
    sed -i '/error_log = php_errors.log/c error_log = \/dev\/stdout' /etc/php5/cli/php.ini && \
    sed -i '/;sendmail_path/c sendmail_path = /bin/true' /etc/php5/cli/php.ini && \
    # PHP module settings
    echo 'opcache.memory_consumption=128' >> /etc/php5/mods-available/opcache.ini


COPY config/php5/xdebug.ini /etc/php5/mods-available/xdebug.ini
COPY config/php5/opcache.ini /etc/php5/mods-available/opcache.ini

COPY config/php5-fpm/application.ini /etc/php5/fpm/conf.d/
COPY config/php5-fpm/application.ini /etc/php5/cli/conf.d/

COPY config/php5-fpm/application.pool.conf /etc/php5/fpm/pool.d/

RUN php5dismod -s cli xdebug
RUN php5dismod -s cli opcache
RUN echo insecure >> /home/docker/.curlrc
RUN echo "syntax on" > /home/docker/.vimrc
RUN echo "colorscheme darkblue" >> /home/docker/.vimrc

# Composer
RUN \
    # Composer
    wget https://getcomposer.org/composer.phar && \
    mv composer.phar /usr/local/bin/composer && \
    chmod 777 /usr/local/bin/composer

RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && \
    chmod 777 /usr/local/bin/symfony
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes remove --purge \
    openssl ssl-cert
# Cleanup
RUN apt-get autoremove && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Fix permissions after COPY
RUN sudo chown -R docker:users /home/docker

# Copy configs and scripts
COPY config/.ssh /home/docker/.ssh
COPY config/bashrc /home/docker/.bashrc
COPY startup.sh /opt/startup.sh
RUN chmod 777 /opt/startup.sh
# All further RUN commands will run as the "docker" user
USER docker

# Default SSH key name
ENV SSH_KEY_NAME id_rsa

WORKDIR /var/www/symfony

EXPOSE 9000 9001

# Starter script
ENTRYPOINT ["/opt/startup.sh"]

CMD ["sudo", "php5-fpm", "-F"]
