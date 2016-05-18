FROM alpine:3.3

ENV ELASTICSEARCH_VERSION 1.4.4

RUN \
  mkdir -p /opt && \
  cd /tmp \
  && apk add --quiet --update ca-certificates curl \
  && apk add openjdk8-jre-base --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
  && curl https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz > elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  tar -xzf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  rm -rf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  mv elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch \
  && apk del ca-certificates curl \
  && rm -rf /var/cache/apk/*

ADD ./elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml
ADD ./docker-entrypoint.sh /docker-entrypoint.sh

VOLUME ["/var/lib/elasticsearch"]

EXPOSE 9200
EXPOSE 9300

CMD ["/docker-entrypoint.sh"]
