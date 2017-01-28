####################################
# DTuX Amzon linux        #
####################################
FROM amazonlinux:latest

# Ensure UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
ENV PHP_BASE /etc/php
# Updating system
RUN yum clean all && yum -y update
# Tools
RUN yum -y install httpd24 vim zip unzip wget gcc-c++ make

# Installing PHP
#RUN apt-get install -y php7.0 php7.0-cli php7.0-common php7.0-dom php7.0-mysql php7.0-xdebug libapache2-mod-php7.0
RUN yum -y install php70 php70-pdo php70-mysqlnd php70-cli php70-mbstring \
    php70-xml php70-intl php70-opcache php70-bcmath php70-apcu php70-imap \
    php70-zip php70-ldap php70-mcrypt php70-gd apcu70-panel php70-devel php7-pear gcc

RUN alternatives --set php /usr/bin/php-7.0
RUN ln -s /usr/bin/pecl7 /usr/bin/pecl
RUN pecl install xdebug-2.5.0
RUN curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -
RUN yum install -y nodejs

# Installing Composer
RUN cd /tmp && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/sbin/composer

RUN curl -fsSL "https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar" -o /usr/local/bin/phpcbf
RUN curl -fsSL "https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar" -o /usr/local/bin/phpcs
RUN curl -L https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.0.0/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer
RUN chmod 777 /usr/local/sbin/composer /usr/local/bin/phpcbf /usr/local/bin/phpcs /usr/local/bin/php-cs-fixer

RUN yum remove -y php70-devel php7-pear gcc
# Enabling Virtual Host
COPY ./symfony.conf /etc/httpd/conf.d/symfony.conf
COPY php/20-xdebug.ini /etc/php/20-xdebug.ini
COPY php/10-opcache.ini /etc/php/10-opcache.ini
COPY php/10-php.ini /etc/php/10-php.ini

WORKDIR "/var/www"

# Expose ports
EXPOSE 80
EXPOSE 9000

# Fixing boot2docker error
RUN usermod -u 1000 apache

# Copy configs and scripts
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN mkdir -p /run/php && mkdir -p /var/www/ && chmod 777 /run/php && chmod 777 /bin/docker-entrypoint.sh

# Starter script
ENTRYPOINT ["/bin/docker-entrypoint.sh"]

#Running in background
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
#CMD ["php", "-a"]
