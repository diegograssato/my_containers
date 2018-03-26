####################################
# Node workwe      #
####################################
FROM node:7.9.0-alpine

MAINTAINER Diego Pereira Grassato <diego.grassato@gmail.com>

# Ensure UTF-8
ENV LC_ALL          C.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8

RUN npm install -g gulp bower

WORKDIR /worker

RUN apk add --update bash
# Copy configs and scripts
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN mkdir -p /worker && chmod 777 /bin/docker-entrypoint.sh

USER node
# Starter script
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
# Starter script
CMD ["/bin/bash"]
