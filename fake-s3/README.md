# Local ElasticSNS
Here is an unofficial Dockerfile for [fake-s3][fake-s3].

Amazon Simple Storage Service (Amazon S3)

[![](https://images.microbadger.com/badges/version/diegograssato/fake-s3.svg)](https://microbadger.com/images/diegograssato/fake-s3 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/diegograssato/fake-s3.svg)](https://microbadger.com/images/diegograssato/fake-s3 "Get your own image badge on microbadger.com")

## Usage

Get it:

    docker pull diegograssato/fake-s3

Run it:

    docker run -d -p 4569:4569 --name fake-s3 diegograssato/fake-s3

Then you can configure database using web interface: http://\<your docker host\>:9911/.

## Personalize ports and hosts, an the docker-composer.yml

    fake-s3:
        image: diegograssato/fake-s3
        ports:
            - 4569:4569

## Build

Just clone this repo and run:

    docker build -t diegograssato/fake-s3 .

[fake-s3]: https://aws.amazon.com/pt/s3 "What Is Amazon S3?"
[dockerhubpage]: https://hub.docker.com/r/diegograssato/fake-s3/ " Amazon Simple Storage Service (Amazon S3) docker hub page"
