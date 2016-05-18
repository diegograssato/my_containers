#!/usr/bin/env bash

UPSTREAM="/etc/nginx/conf.d/upstream.conf"
NGINX_CONF="/etc/nginx/nginx.conf"
NGINX_CONF_AVAILABLE="/etc/nginx/sites-available/nginx.conf"
APP_AVAILABLE="/etc/nginx/sites-available/application.conf"
APP="/etc/nginx/sites-enabled/application.conf"

echo -e "\n Cleaning configuration files"
cp -a ${APP_AVAILABLE} ${APP}
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
[ -f ${UPSTREAM} ] && rm ${UPSTREAM}
if [ ! -z ${PHP_FPM_SOCKET} ]; then
    echo "upstream php-upstream { server ${PHP_FPM_SOCKET}; }" > ${UPSTREAM}
fi

if [ ! -z ${APP_SERVER_NAME} ]; then
    export APP_SERVER_NAME="localhost"
fi

if [ -z ${DOCUMENT_ROOT} ]; then
    export DOCUMENT_ROOT="/var/www"
fi

if [ -z ${APP_INDEX_FILE} ]; then
    export APP_INDEX_FILE="index.php"
fi

if [ -z ${APP_SERVER_HTTP} ]; then
    export APP_SERVER_HTTP=80
fi

if [ -z ${APP_SERVER_HTTPS} ]; then
    export APP_SERVER_HTTPS=443
fi

${SED} -i "s@<APP_SERVER_NAME>@${APP_SERVER_NAME}@" ${APP}
${SED} -i "s@<DOCUMENT_ROOT>@${DOCUMENT_ROOT}@" ${APP}
${SED} -i "s@<APP_INDEX_FILE>@${APP_INDEX_FILE}@" ${APP}

${SED} -i "s@<APP_SERVER_HTTP>@${APP_SERVER_HTTP}@" ${APP}
${SED} -i "s@<APP_SERVER_HTTPS>@${APP_SERVER_HTTPS}@" ${APP}

[ ! -d /etc/nginx/ssl ] && mkdir -p /etc/nginx/ssl/

if [ ! -f /etc/nginx/ssl/nginx.key ]; then

    echo -e "n\ Generating self signed cert"
    openssl req -x509 -newkey rsa:4086 \
        -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/mCN=localhost" \
        -keyout "/etc/nginx/ssl/nginx.key" \
        -out "/etc/nginx/ssl/nginx.crt" \
        -days 3650 -nodes -sha256

fi
# Execute passed CMD arguments
exec "$@"