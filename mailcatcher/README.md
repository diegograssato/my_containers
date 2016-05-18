# Mailcatcher docker image

Here is an unofficial Dockerfile for [mailcatcher][mailcatcher].

You can find several versions of this image in [the dedicated docker hub page][dockerhubpage].  
It is a pretty light image: ~ 41 MB uncompressed.

## Usage

Get it:

    docker pull diegograssato/mailcatcher

Run it:

    docker run -d -p 1080:1080 --name smtp diegograssato/mailcatcher

Then you can send emails from your app and check out the web interface: http://\<your docker host\>:1080/.


If you want to send emails from your host you can map the 1025 port:

    docker run -d -p 1080:1080 -p 1025:1025 --name mail diegograssato/mailcatcher

then send yout emails through your docker host on port 1025 (or any port you want)

## Personalize ports and hosts, an the docker-composer.yml

    mailcatcher:
        image: diegograssato/mailcatcher
        ports:
            - 1080:80
            - 1025:25
        environment:
            SMTP_IP: 192.168.10.1
            SMTP_PORT: 25
            HTTP_IP: 192.168.10.1
            HTTP_PORT: 80


## Build

Just clone this repo and run:

    docker build -t diegograssato/mailcatcher .


  [mailcatcher]: http://mailcatcher.me/ "MailCatcher fake SMTP server with web interface"
  [dockerhubpage]: https://hub.docker.com/r/diegograssato/mailcatcher/ "Mailcatcher docker hub page"
