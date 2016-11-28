# Local Elasticmq
Here is an unofficial Dockerfile for [elasticmq-server][elasticmq-server].

Amazon Simple Queue Service (Amazon SQS) local.

[![](https://images.microbadger.com/badges/version/diegograssato/elasticmq-server.svg)](https://microbadger.com/images/diegograssato/elasticmq-server "Get your own version badge on microbadger.com")

## Usage

Get it:

    docker pull diegograssato/elasticmq-server

Run it:

    docker run -d -p 9324:9324 --name elasticmq-server diegograssato/elasticmq-server

Then you can configure database using web interface: http://\<your docker host\>:9324/.

## Personalize ports and hosts, an the docker-composer.yml

    elasticmq-server:
        image: diegograssato/elasticmq-server
        ports:
            - 9324:9324

## Build

Just clone this repo and run:

    docker build -t diegograssato/elasticmq-server .


  [dockerhubpage]: https://hub.docker.com/r/diegograssato/elasticmq-server/ "DynamoDB docker hub page"
