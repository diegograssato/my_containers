#!/bin/bash

echo "==============================="
echo " Starting DynamoDB. "
echo "==============================="

exec java -Djava.library.path=/usr/local/src/dynamodb/DynamoDBLocal_lib -jar /usr/local/src/dynamodb/DynamoDBLocal.jar $@
