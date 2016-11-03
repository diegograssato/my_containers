FROM debian:jessie

MAINTAINER Diego Perera Grassato <diego.grassato@gmail.com>
# Ensure UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
ENV SUPPORTED_LANGUAGES="en_US|pt_BR"
# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN sed -i 's/main/main contrib non-free/' /etc/apt/sources.list && \
    echo "deb http://http.debian.net/debian/ jessie-backports main contrib non-free" >>  /etc/apt/sources.list && \
    DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 libapache2-mod-fastcgi libapache2-mod-macro \
                    apache2-mpm-worker ca-certificates openssl ssl-cert locales  \
                    # Generate base locale
    && cat /usr/share/i18n/SUPPORTED | grep -E "$SUPPORTED_LANGUAGES" > /etc/locale.gen \
    && locale-gen

RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    apt-get purge -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/

RUN  a2enmod actions fastcgi ssl rewrite headers expires macro vhost_alias vhost_alias
COPY ./conf-enabled/*.conf /etc/apache2/conf-enabled/
COPY ./sites-enabled/*.conf /etc/apache2/sites-enabled/
COPY ./conf-available/*.conf /etc/apache2/conf-available/
COPY start.sh /bin/
RUN chmod 777 /bin/start.sh

WORKDIR /var/www

# Starter script
CMD ["/bin/start.sh"]
