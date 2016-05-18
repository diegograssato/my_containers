FROM alpine:3.3

MAINTAINER Diego Perera Grassato <diego.grassato@gmail.com>

RUN apk --update add py-pip jq bash && pip install awscli && rm -rf /var/cache/apk/*

CMD ["/bin/bash"]
