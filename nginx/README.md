# Nginx docker image

Here is an unofficial Dockerfile for [nginx][nginx].

You can find several versions of this image in [the dedicated docker hub page][dockerhubpage].  
It is a pretty light image: ~ 10 MB uncompressed.

## Usage

Get it:

    docker pull diegograssato/nginx

Run it:

    docker run -d -p 80:80 -p 443:443 --name web diegograssato/nginx 

## Personalize ports and hosts, an the docker-composer.yml

    nginx:
        image: diegograssato/nginx
        ports:
            - 80:80
            - 443:443
        environment:
            DOCUMENT_ROOT: /var/www/symfony/web
            DNSDOCK_ALIAS: symfony.dev
            INDEX_FILE: app_dev.php
            PHP_FPM_SOCKET: sf_php7:9011

## Build

Just clone this repo and run:

    docker build -t diegograssato/nginx .


  [dockerhubpage]: https://hub.docker.com/r/diegograssato/mailcatcher/ "Mailcatcher docker hub page"
  [nginx]:git@github.com:diegograssato/my_containers.git/nginx "Nginx source code"