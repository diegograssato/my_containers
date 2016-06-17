# PHP7 docker image

Here is an unofficial Dockerfile for [php7][php7].

You can find several versions of this image in [the dedicated docker hub page][dockerhubpage].   

## Usage

Get it:

    docker pull diegograssato/php7

Run it:

    docker run --name php7 diegograssato/php7
 

## Found modules available:


    apcu
    apcu_bc
    bz2
    curl
    enchant
    gd
    geoip
    gmp
    igbinary
    imagick
    imap
    intl
    json
    mcrypt
    memcached
    mongodb
    msgpack
    mysqli
    opcache
    pspell
    readline
    recode
    redis
    sqlite3
    xdebug
    xmlrpc
    xsl
    pdo_dblib
    pdo_mysql
    pdo_pgsql
    pdo_sqlite
    sysbase


## Build

Just clone this repo and run:

    docker build -t diegograssato/php7 .
    docker push diegograssato/php7


  [dockerhubpage]: https://hub.docker.com/r/diegograssato/php7/ "PHP7 docker hub page"
  [php7]:git@github.com:diegograssato/my_containers.git/php7 "PHP7 source code"
