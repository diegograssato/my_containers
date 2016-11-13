#!/bin/bash

[[ -z "${MEMORY}" ]] && MEMORY=false

if [[ "${MEMORY}" == "true" ]]; then
    INMEMORY="-inMemory"
fi


if [[ "${SHARED}" == "true" ]]; then
    SHAREDDB="-sharedDb"
fi

if [[ -d "${DBPATH}" ]]; then

    DPATH="-dbPath ${DBPATH}"

elif [ "${MEMORY}" == "false" ]; then

    mkdir -p /var/dynamodb_local
    DPATH="-dbPath /var/dynamodb_local"
fi

if [[ -z "${PORT}" ]]; then
    PORT=8000
fi

echo "===================================================================="
echo " Starting DynamoDB: web access -> http://localhost:${PORT}/shell/ "
echo "===================================================================="

exec java -Djava.library.path=/usr/local/src/dynamodb/DynamoDBLocal_lib \
    -jar /usr/local/src/dynamodb/DynamoDBLocal.jar \
    -port ${PORT} ${INMEMORY} ${SHAREDDB} ${DPATH}
