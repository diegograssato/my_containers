#!/usr/bin/env bash

UPSTREAM="/etc/nginx/conf.d/upstream.conf"
NGINX_CONF="/etc/nginx/nginx.conf"
NGINX_CONF_AVAILABLE="/etc/nginx/sites-available/nginx.conf"
APP_AVAILABLE="/etc/nginx/sites-available/application.conf"
APP_DEFAULT="/etc/nginx/sites-available/default.conf"
SITES_ENABLED="/etc/nginx/sites-enabled/"

echo -e "\n Cleaning configuration files"

cp -a ${NGINX_CONF_AVAILABLE} ${NGINX_CONF}

SED=$(which sed)

if [ -z ${NGINX_WORKER_PROCESSES} ]; then
    export NGINX_WORKER_PROCESSES=$(grep processor /proc/cpuinfo | wc -l)
fi

if [ -z ${NGINX_CONNECTIONS} ]; then
    export NGINX_CONNECTIONS=$((${NGINX_WORKER_PROCESSES}*5120))
fi
${SED} -i "s@<NGINX_WORKER_PROCESSES>@${NGINX_WORKER_PROCESSES}@" ${NGINX_CONF}
${SED} -i "s@<NGINX_CONNECTIONS>@${NGINX_CONNECTIONS}@" ${NGINX_CONF}

################### ################### ################### ################### ###################


if [ -z ${APP_SERVER_NAME} ]; then
    export APP_SERVER_NAME="localhost"
fi

if [ -z ${DOCUMENT_ROOT} ]; then
    export DOCUMENT_ROOT="/var/www"
fi

if [ -z ${APP_INDEX_FILE} ]; then
    export APP_INDEX_FILE="index.html index.htm index.php"
fi

if [ -z ${APP_SERVER_HTTP} ]; then
    export APP_SERVER_HTTP=80
fi

if [ -z ${APP_SERVER_HTTPS} ]; then
    export APP_SERVER_HTTPS=443
fi

[ -f ${UPSTREAM} ] && rm ${UPSTREAM}
if [ ! -z ${PHP_FPM_SOCKET} ]; then

    echo "upstream php-upstream { server ${PHP_FPM_SOCKET}; }" > ${UPSTREAM}
    cp -a ${APP_AVAILABLE} ${SITES_ENABLED}

else

    cp -a ${APP_DEFAULT} "${SITES_ENABLED}/application.conf"
fi

mkdir -p ${DOCUMENT_ROOT}
${SED} -i "s@<APP_SERVER_NAME>@${APP_SERVER_NAME}@" "${SITES_ENABLED}/application.conf"
${SED} -i "s@<DOCUMENT_ROOT>@${DOCUMENT_ROOT}@" "${SITES_ENABLED}/application.conf"
${SED} -i "s@<APP_INDEX_FILE>@${APP_INDEX_FILE}@" "${SITES_ENABLED}/application.conf"

${SED} -i "s@<APP_SERVER_HTTP>@${APP_SERVER_HTTP}@" "${SITES_ENABLED}/application.conf"
${SED} -i "s@<APP_SERVER_HTTPS>@${APP_SERVER_HTTPS}@" "${SITES_ENABLED}/application.conf"

[ ! -d /etc/nginx/ssl ] && mkdir -p /etc/nginx/ssl/

if [ ! -f /etc/nginx/ssl/nginx.key ]; then

    echo -e "\n Generating self signed cert"
    openssl req -x509 -newkey rsa:4086 \
        -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/mCN=localhost" \
        -keyout "/etc/nginx/ssl/nginx.key" \
        -out "/etc/nginx/ssl/nginx.crt" \
        -days 3650 -nodes -sha256

fi

# Execute passed CMD arguments
exec "$@"
