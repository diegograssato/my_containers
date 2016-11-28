# Local DynamoDB
Here is an unofficial Dockerfile for [mini-dynamodb][mini-dynamodb].


[![](https://badge.imagelayers.io/diegograssato/mini-dynamodb:latest.svg)](https://imagelayers.io/?images=diegograssato/mini-dynamodb:latest 'Get your own badge on imagelayers.io')

You can find several versions of this image in [the dedicated docker hub page][dockerhubpage].  
Amazon DynamoDB is a fully managed NoSQL database service that provides fast and predictable performance with seamless scalability. DynamoDB lets you offload the administrative burdens of operating and scaling a distributed database, so that you don't have to worry about hardware provisioning, setup and configuration, replication, software patching, or cluster scaling.

## Usage

Get it:

    docker pull diegograssato/mini-dynamodb

Run it:

    docker run -d -p 8000:8000 --name mini-dynamodb diegograssato/mini-dynamodb

Then you can configure database using web interface: http://\<your docker host\>:8000/.

## Personalize ports and hosts, an the docker-composer.yml

    mini-dynamodb:
        image: diegograssato/mini-dynamodb
        ports:
            - 8000:8000

## Build

Just clone this repo and run:

    docker build -t diegograssato/mini-dynamodb .


  [mini-dynamodb]: http://docs.aws.amazon.com/amazonmini-dynamodb/latest/developerguide/Introduction.html "What Is Amazon DynamoDB?"
  [dockerhubpage]: https://hub.docker.com/r/diegograssato/mini-dynamodb/ "DynamoDB docker hub page"
