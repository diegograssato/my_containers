####################################
# CLI                             #
####################################
FROM diegograssato/php7:7.1

MAINTAINER Diego Pereira Grassato <diego.grassato@gmail.com>

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
ENV SUPPORTED_LANGUAGES="en_US|pt_BR"
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    openssl ssl-cert ca-certificates sudo mysql-client unzip default-jre \
    vim curl wget locales git openssh-client php7.1-cli php7.1-dev build-essential make && \
    cat /usr/share/i18n/SUPPORTED | grep -E "$SUPPORTED_LANGUAGES" > /etc/locale.gen && \
    locale-gen && \
    # Create a non-root user with access to sudo and the default group set to 'users' (gid = 100)
    useradd -m -s /bin/bash -g users -u 1000 -G sudo,ssh -p docker docker && \
    echo 'docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Ensure UTF-8
ENV LC_ALL          C.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8

# Configure VIM to PHP development
RUN mkdir -p /home/docker/.vim/bundle && \
    git clone https://github.com/StanAngeloff/php.vim.git /home/docker/.vim/bundle/php.vim

# Composer
RUN \
    # Composer
    curl -LsS https://getcomposer.org/composer.phar -o /usr/local/bin/composer && \
    chmod 777 /usr/local/bin/composer

RUN DEBIAN_FRONTEND=noninteractive apt-get remove php7.1-fpm php-uploadprogress --purge -y && \
    apt-get upgrade -y && \
    apt-get purge -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/

# Copy configs and scripts
COPY config/.ssh /home/docker/.ssh
COPY config/bashrc /home/docker/.bashrc
COPY config/bash_aliases /home/docker/.bash_aliases
COPY config/inputrc /home/docker/.inputrc
ADD sonar-scanner-2.6.zip /opt/

# Copy configs and scripts
COPY docker-entrypoint.sh /bin/
RUN chmod 777 /bin/docker-entrypoint.sh

# All further RUN commands will run as the "docker" user
USER docker

# Fix permissions after COPY
RUN sudo chown -R docker:users /home/docker

WORKDIR /var/www/html

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
# Starter script
CMD ["bash"]
