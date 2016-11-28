#!/bin/bash

echo "===================================================================="
echo " Starting ElasticMQ server"
echo "===================================================================="

exec java -Djava.net.preferIPv4Stack=true \
    -Dconfig.file=/etc/elasticmq/elasticmq.conf \
    -jar /usr/local/src/elasticmq-server/elasticmq-server.jar
