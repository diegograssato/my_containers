FROM java:8-jre-alpine

MAINTAINER Diego Perera Grassato <diego.grassato@gmail.com>

ENV AWS_DEFAULT_REGION=eu-west-1 \
	AWS_ACCESS_KEY_ID=foo \
	AWS_SECRET_ACCESS_KEY=bar \
	VERSION=0.9.3

# aws-cli
RUN apk -Uuv add curl
RUN mkdir -p /usr/local/src/elasticmq-server && cd  /usr/local/src/elasticmq-server && mkdir -p /etc/elasticmq && \
  /usr/bin/curl -sL https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-0.12.1.jar -o /usr/local/src/elasticmq-server/elasticmq-server.jar   && \
	rm /var/cache/apk/*

# Copy configs and scripts
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod 777 /bin/docker-entrypoint.sh
RUN mkdir -p /etc/elasticmq
COPY elasticmq.conf /etc/elasticmq/elasticmq.conf

# Default port for SNS Local
EXPOSE 9324

# Starter script
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/java", "-Djava.net.preferIPv4Stack=true", "-Dconfig.file=/etc/elasticmq/elasticmq.conf", "-jar", "/usr/local/src/elasticmq-server/elasticmq-server.jar" ]
