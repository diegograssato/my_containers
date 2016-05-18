FROM java:8-jre

RUN mkdir -p /usr/local/src/dynamodb && \
  /usr/bin/curl -sL http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest \
  | /bin/tar xz --no-same-owner -C /usr/local/src/dynamodb && \
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

# Copy configs and scripts
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod 777 /bin/docker-entrypoint.sh

# Starter script
ENTRYPOINT ["/bin/docker-entrypoint.sh"]

CMD ["-help"]
