#!/bin/sh

# if [[ -z "${PORT}" ]]; then
#     PORT="9324"
# fi
#
# if [[ -z "${ADDRESS}" ]]; then
#     ADDRESS="0.0.0.0"
# fi
#
# if [[ -z "${SERVER}" ]]; then
#     SERVER="webrick"
# fi
#
# echo -e "\n===================================================================="
# echo " Starting SQS server: http://${ADDRESS}:${PORT}     "
# echo "===================================================================="
#
# # Execute passed CMD arguments
# exec ${@} --bind ${ADDRESS} --port ${PORT} --server ${SERVER}
CONTAINER_ID=$(hostname)
BRIDGE="127.0.0.1"
BRIDGE=$(cat /etc/hosts|grep $CONTAINER_ID|cut -s -f1)
if [[ ! -z $BRIDGE_HOST ]]; then BRIDGE=$BRIDGE_HOST; fi

CONFIG=$(cat <<EOF
// https://github.com/adamw/elasticmq#installation-stand-alone
include classpath("application.conf")
node-address {
    protocol = http
    host = $BRIDGE
    port = 9324
    context-path = ""
}
rest-sqs {
    enabled = true
    bind-port = 9324
    bind-hostname = "0.0.0.0"
    // Possible values: relaxed, strict
    sqs-limits = strict
}
queues {
    queue1 {
        defaultVisibilityTimeout = 10 seconds
        delay = 5 seconds
        receiveMessageWait = 0 seconds
    },
    symfony {
        defaultVisibilityTimeout = 10 seconds
        delay = 5 seconds
        receiveMessageWait = 0 seconds
    }
}
EOF
)
echo -e "$CONFIG" > /etc/elasticmq/elasticmq.conf
echo -e "\n===================================================================="
echo " Starting ElasticMQ server"
echo "===================================================================="

#
exec java -Djava.net.preferIPv4Stack=true \
    -Dconfig.file=/etc/elasticmq/elasticmq.conf \
    -jar /usr/local/src/elasticmq-server/elasticmq-server.jar
