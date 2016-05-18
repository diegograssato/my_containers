#!/usr/bin/env bash

if [ -z ${SMTP_PORT} ]; then
    export SMTP_PORT=1025
fi

if [ -z ${SMTP_IP} ]; then
    export SMTP_IP='0.0.0.0'
fi

if [ -z ${HTTP_IP} ]; then
    export HTTP_IP='0.0.0.0'
fi

if [ -z ${HTTP_PORT} ]; then
    export HTTP_PORT=1080
fi
echo "==============================="
echo " Starting mailcatcher. "
echo " $@ --ip=${SMTP_IP} --smtp-port=${SMTP_PORT} --http-ip=${HTTP_IP} --http-port=${HTTP_PORT}"
echo "==============================="
# Execute passed CMD mailcatcher --foreground + arguments
exec $@ --ip=${SMTP_IP} --smtp-port=${SMTP_PORT} --http-ip=${HTTP_IP} --http-port=${HTTP_PORT}
