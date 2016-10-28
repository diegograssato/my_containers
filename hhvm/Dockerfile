FROM debian:jessie


ENV HHVM_VERSION need-to-add-versioning

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 && \
    echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list

RUN apt-get update -y \
    && apt-get install -y hhvm && \
    apt-get purge -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/


#RUN mkdir -p /var/www/laravel
ADD ./server.ini /etc/hhvm/server.ini
ADD ./php.ini /etc/hhvm/php.ini

#RUN usermod -u 1000 www-data

WORKDIR /var/www


CMD ["/usr/bin/hhvm", "-m", "server", "-c", "/etc/hhvm/server.ini"]

EXPOSE 9000
