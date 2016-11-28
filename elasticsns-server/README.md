# Local ElasticSNS
Here is an unofficial Dockerfile for [elasticsns-server][elasticsns-server].

Amazon Simple Notification Service (SNS) local.

[![](https://images.microbadger.com/badges/version/diegograssato/elasticsns-server.svg)](https://microbadger.com/images/diegograssato/elasticsns-server "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/diegograssato/elasticsns-server.svg)](https://microbadger.com/images/diegograssato/elasticsns-server "Get your own image badge on microbadger.com")

## Usage

Get it:

    docker pull diegograssato/elasticsns-server

Run it:

    docker run -d -p 9911:9911 --name elasticsns-server diegograssato/elasticsns-server

Then you can configure database using web interface: http://\<your docker host\>:9911/.

## Personalize ports and hosts, an the docker-composer.yml

    elasticsns-server:
        image: diegograssato/elasticsns-server
        ports:
            - 9911:9911

## Build

Just clone this repo and run:

    docker build -t diegograssato/elasticsns-server .


[dockerhubpage]: https://hub.docker.com/r/diegograssato/elasticsns-server/ " Amazon Simple Notification Service (SNS) docker hub page"
