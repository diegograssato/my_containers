FROM java:8-jre-alpine

MAINTAINER Diego Perera Grassato <diego.grassato@gmail.com>

ENV AWS_DEFAULT_REGION=eu-west-1 \
	AWS_ACCESS_KEY_ID=foo \
	AWS_SECRET_ACCESS_KEY=bar \
	DB_PATH="/etc/sns/db.json" \
	HTTP_INTERFACE="0.0.0.0" \
	HTTP_PORT="9911" \
	VERSION=0.1.3

# aws-cli
RUN apk -Uuv add python py-pip curl && \
	pip install awscli
RUN curl -LsS https://github.com/s12v/sns/releases/download/$VERSION/sns-$VERSION.jar -o /bin/sns.jar && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN mkdir -p /etc/sns
COPY db.json /etc/sns/db.json
RUN chmod 777 /docker-entrypoint.sh
 
# Default port for SNS Local
EXPOSE 9911

# Starter script
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/bin/java", "-jar", "/bin/sns.jar"]
