FROM alpine:3.4

MAINTAINER Diego Perera Grassato <diego.grassato@gmail.com>

EXPOSE 8000

ENV DATADIR /var/lib/dynalite

RUN \
  mkdir $DATADIR && \
  apk add --no-cache python make g++ nodejs && \
  npm install -g dynalite && \
  apk del python make g++ && \
  rm -rf /tmp/* /var/cache/apk/*

WORKDIR /var/lib/dynalite

VOLUME $DATADIR

ENTRYPOINT ["dynalite", "--path", "/var/lib/dynalite", "--port", "8000", "--createTableMs", "0", "--deleteTableMs", "0", "--updateTableMs", "0"]
