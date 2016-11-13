# Local DynamoDB
Here is an unofficial Dockerfile for [dynamodb][dynamodb].

You can find several versions of this image in [the dedicated docker hub page][dockerhubpage].  
Amazon DynamoDB is a fully managed NoSQL database service that provides fast and predictable performance with seamless scalability. DynamoDB lets you offload the administrative burdens of operating and scaling a distributed database, so that you don't have to worry about hardware provisioning, setup and configuration, replication, software patching, or cluster scaling.

## Usage

Get it:

    docker pull diegograssato/dynamodb

Run it:

    docker run -d -p 8000:8000 --name dynamodb diegograssato/dynamodb

Then you can configure database using web interface: http://\<your docker host\>:8000/.

## Personalize ports and hosts, an the docker-composer.yml

    dynamodb:
        image: diegograssato/dynamodb
        ports:
            - 8000:8000

## Build

Just clone this repo and run:

    docker build -t diegograssato/dynamodb .


  [dynamodb]: http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html "What Is Amazon DynamoDB?"
  [dockerhubpage]: https://hub.docker.com/r/diegograssato/dynamodb/ "DynamoDB docker hub page"
