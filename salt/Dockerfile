FROM debian:jessie 

LABEL maintainer="Diego Pereira Grassato <diego.grassato@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_VERSION 8
ENV SALT_VERSION 2017.7
ENV REFRESHED_AT 2017-01-31
ENV SALT_CONFIG "/etc/salt"

# Ensure UTF-8
ENV LC_ALL          C.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8
 
# Update system
RUN apt-get update -qq && \
	apt-get install -yqq \
	wget \
	curl \
	vim \
	dnsutils \
	python-pip \
	python-dev \
	python-apt \
	python-git \
	python-openssl \
	openssh-client \
	reclass \
	software-properties-common \
	dmidecode \
	python-cherrypy3 \
	virt-what \
	net-tools \
	procps \
	pciutils \
	python-yaml \
	python-requests \
	python-jinja2 \
	python-m2crypto \
	python-mako \
	libgit2-dev

# Install salt master/minion/cloud/api and setup halite
RUN echo "deb http://repo.saltstack.com/apt/debian/${DEBIAN_VERSION}/amd64/${SALT_VERSION} jessie main" > /etc/apt/sources.list.d/salt.list && \
	wget -q -O- https://repo.saltstack.com/apt/debian/${DEBIAN_VERSION}/amd64/${SALT_VERSION}/SALTSTACK-GPG-KEY.pub | apt-key add - && \
	apt-get update -qq && \
	apt-get install -yqq \
	salt-master \
	salt-minion \
	salt-cloud \
	salt-api \
	salt-ssh \
	python-ioflo \
	salt-syndic && \
	pip install docker-py halite

# Clean image
RUN apt-get purge -y && \
	apt-get clean -y && \
	apt-get autoclean -y && \
	apt-get autoremove -y && \
	rm -rf /usr/share/locale/* && \
	rm -rf /var/cache/* && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /usr/share/doc/

# Add salt config files
ADD etc/master /etc/salt/master
ADD etc/minion /etc/salt/minion
ADD etc/reactor.conf /etc/salt/master.d/reactor.conf
ADD etc/salt-api.conf /etc/salt/master.d/salt-api.conf

# Expose volumes
VOLUME ["/etc/salt", "/var/cache/salt", "/var/logs/salt"]

# Exposing salt master and api ports
EXPOSE 4505 4506 8080 8081
 
# Add and set start script
# Copy configs and scripts
COPY docker-entrypoint.sh /bin/
RUN chmod 777 /bin/docker-entrypoint.sh
CMD ["bash", "/bin/docker-entrypoint.sh"]