#!/bin/sh

if [[ ! -d "${DIR}" ]]; then
    DIR="/var/fakes3_root"
fi

if [[ -z "${PORT}" ]]; then
    PORT="4569"
fi

if [[ ! -z "${RATE}" ]]; then
    RATE="-l ${RATE}"
fi

if [[ -z "${ADDRESS}" ]]; then
    ADDRESS="0.0.0.0"
fi

if [[ -z "${SHOSTNAME}" ]]; then
    SHOSTNAME="s3.amazonaws.com"
fi

echo -e "\n===================================================================="
echo " Starting S3 server: http://${ADDRESS}:${PORT}     "
echo "===================================================================="

[[ ! -d ${DIR} ]] && mkdir -p ${DIR} && chmod 777 -R ${DIR}

# Execute passed CMD arguments
exec ${@} --root ${DIR} --port ${PORT} -H ${SHOSTNAME} ${RATE}
