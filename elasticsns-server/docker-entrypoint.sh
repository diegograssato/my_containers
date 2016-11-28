#!/bin/sh

echo -e "\n===================================================================="
echo " Starting ElasticSNS server: http://${HTTP_INTERFACE}:${HTTP_PORT}     "
echo "===================================================================="

# Execute passed CMD arguments
exec "$@"
