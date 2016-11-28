FROM java:8-jre

MAINTAINER Diego Perera Grassato <diego.grassato@gmail.com>

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget locales  && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN mkdir -p /usr/local/src/elasticmq-server && cd  /usr/local/src/elasticmq-server && \
  /usr/bin/curl -sL https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-0.9.3.jar -o /usr/local/src/elasticmq-server/elasticmq-server.jar  && \
  apt-get update && \
  apt-get upgrade -y && \
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
ENV LC_ALL          C.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8

# Copy configs and scripts
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod 777 /bin/docker-entrypoint.sh
COPY elasticmq.conf /etc/elasticmq/elasticmq.conf

# Default port for SQL Local
EXPOSE 9324

# Starter script
ENTRYPOINT ["/bin/docker-entrypoint.sh"]

CMD ["-help"]
