# PHP 5.6 docker image

Here is an unofficial Dockerfile for [php5.6][php5.6].

You can find several versions of this image in [the dedicated docker hub page][dockerhubpage].   

## Usage

Get it:

    docker pull diegograssato/php5.6

Run it:

    docker run --name php5.6 diegograssato/php5.6


## Found modules available:


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
    mongo
    msgpack
    mysqli
    pspell
    readline
    recode
    redis
    sqlite
    xcache
    xdebug
    xmlrpc
    xsl
    zip
    pdo_dblib
    pdo_mysql
    pdo_pgsql
    pdo_sqlite
    ldap
    sysbase


## Build

Just clone this repo and run:

    docker build -t diegograssato/php5.6 .
    docker push diegograssato/php5.6


  [dockerhubpage]: https://hub.docker.com/r/diegograssato/php5.6/ "PHP 5.6 docker hub page"
  [php5.6]:git@github.com:diegograssato/my_containers.git/php5.6 "PHP 5.6 source code"
