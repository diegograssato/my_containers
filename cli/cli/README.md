# CLI

Here is an unofficial Dockerfile for [cli][cli].

You can find several versions of this image in [the dedicated docker hub page][dockerhubpage].   

## Usage

Get it:

    docker pull diegograssato/cli

Run it:

    docker run --name cli diegograssato/cli
 

## Build

Just clone this repo and run:

    docker build -t diegograssato/cli .
    docker push diegograssato/cli


  [dockerhubpage]: https://hub.docker.com/r/diegograssato/cli/ "CLI docker hub page"
  [cli]:git@github.com:diegograssato/my_containers.git/cli "CLI source code"
