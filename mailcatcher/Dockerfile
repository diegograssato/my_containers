FROM alpine:3.3

MAINTAINER Diego Perera Grassato <diego.grassato@gmail.com>

ENV MAILCATCHER_VERSION 0.6.4

RUN \
    buildDeps=" \
        ruby-dev \
        make g++ \
        sqlite-dev \
        openssl-dev \
    " && \
    apk add --no-cache ruby ruby-bigdecimal bash sqlite-libs libstdc++ $buildDeps && \
    gem install -v $MAILCATCHER_VERSION mailcatcher --no-ri --no-rdoc && \
    apk del $buildDeps && \
    rm -rf /var/cache/apk/*

# default smtp port
EXPOSE 1025

# default webserver port
EXPOSE 1080

COPY docker-entrypoint.sh /
RUN chmod 777 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mailcatcher", "--foreground"]
