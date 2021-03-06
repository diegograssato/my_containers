#!/bin/bash

UPSTREAM_CONF="/etc/nginx/conf.d/default-upstream.conf"
NGINX_CONF="/etc/nginx/nginx.conf"
NGINX_CONF_AVAILABLE="/etc/nginx/sites-available/nginx.conf"
APP_AVAILABLE="/etc/nginx/sites-available/application.conf"
APP_DEFAULT="/etc/nginx/sites-available/default.conf"
TEMPLATE_SYMFONY="/etc/nginx/sites-available/symfony.conf"
APP_CUSTOM="/etc/nginx/sites-available/custom.conf"
SITES_ENABLED="/etc/nginx/sites-enabled"
SITES_AVAILABLE="/etc/nginx/sites-available"
SITES_ENABLEDx="/tmp"

SED=$(which sed)
CP=$(which cp)

echo -e "\n Cleaning configuration files"
${CP} -va ${NGINX_CONF_AVAILABLE} ${NGINX_CONF}


if [[ -z ${NGINX_WORKER_PROCESSES} ]]; then
    export NGINX_WORKER_PROCESSES=$(grep processor /proc/cpuinfo | wc -l)
fi
if [[ -z ${NGINX_WORKER_PROCESSES} ]]; then
    export NGINX_WORKER_PROCESSES=$(grep processor /proc/cpuinfo | wc -l)
fi

if [[ -z ${NGINX_CONNECTIONS} ]]; then
    export NGINX_CONNECTIONS=$((${NGINX_WORKER_PROCESSES}*5120))
fi
${SED} -i "s@<NGINX_WORKER_PROCESSES>@${NGINX_WORKER_PROCESSES}@" ${NGINX_CONF}
${SED} -i "s@<NGINX_CONNECTIONS>@${NGINX_CONNECTIONS}@" ${NGINX_CONF}

################### ################### ################### ################### ###################
if [[ -z ${DOCUMENT_ROOT} ]]; then
    export DOCUMENT_ROOT="/var/www"
fi

function site_configuration() {

    if [[ -z ${APP_SERVER_NAME} ]]; then
        export APP_SERVER_NAME="localhost"
    fi

    if [[ -z ${NGINX_DOCUMENT_ROOT} ]]; then
        export NGINX_DOCUMENT_ROOT="/var/www"
    fi

    if [[ -z ${APP_INDEX_FILE} ]]; then
        export APP_INDEX_FILE="index.html index.htm index.php"
    fi

    if [[ -z ${APP_SERVER_HTTP_PORT} ]]; then
        export APP_SERVER_HTTP_PORT=80
    fi

    if [[ -z ${APP_SERVER_HTTPS_PORT} ]]; then
        export APP_SERVER_HTTPS_PORT=443
    fi

    if [[ ${USE_TEMPLATE_SYMFONY} == 'true' ]]; then

        echo -e "\n Using symfony template"
        ${CP} -v ${TEMPLATE_SYMFONY} "${SITES_ENABLED}/"
    #
    # else
    #
    #     ${CP} -v ${APP_DEFAULT} "${SITES_ENABLED}/application.conf"

    fi

    VIRTUAL_HOST_CONFIG="{'vhost':[${VIRTUAL_HOST_CONFIG}]}"
    echo ${VIRTUAL_HOST_CONFIG} > /tmp/vhost.json
    sed -i "s|'|\"|g"  /tmp/vhost.json
    SITE_SIZE=$(jq ".vhost[] .name" /tmp/vhost.json |wc -l)

    for ((x=0; x < ${SITE_SIZE}; x++)) ; do

        SITE=$(jq -r ".vhost[$x] .name" /tmp/vhost.json)
        DOCUMENT_ROOT=$(jq -r ".vhost[$x] .docroot" /tmp/vhost.json)
        MODEL=$(jq -r ".vhost[$x] .model" /tmp/vhost.json)
        if [[ ${MODEL} == "null" ]]; then

            APP_AVAILABLE="${SITES_AVAILABLE}/default.conf"

        else
            APP_AVAILABLE="${SITES_AVAILABLE}/${MODEL}.conf"
        fi

        DOCUMENT_ROOT="${NGINX_DOCUMENT_ROOT}${DOCUMENT_ROOT}"

        SITE_DOMAINS=""
        DOMAINS_SIZE=$(jq -c ".vhost[$x] .domains" /tmp/vhost.json  | jq length)
        APP_SSL=$(jq -r ".vhost[$x] .forcessl" /tmp/vhost.json)
        APP_SOCKET=$(jq -r ".vhost[$x] .socket" /tmp/vhost.json)
        APP_INDEX=$(jq -r ".vhost[$x] .index" /tmp/vhost.json)
        for ((y=0; y < ${DOMAINS_SIZE}; y++)) ; do

            APP_DOMAINS=$(jq -r ".vhost[$x] .domains[$y]" /tmp/vhost.json)
            SITE_DOMAINS="${APP_DOMAINS} ${SITE_DOMAINS}"

        done

        echo -e "\n Configuring ${x} of ${SITE_SIZE} site: ${SITE} in ${DOCUMENT_ROOT}"
        ${CP} -v ${APP_AVAILABLE} "${SITES_ENABLED}/${SITE}.conf"

        if [[ ${APP_SSL} == 'true' ]] ; then

            ${SED} -i "s|<HTTP_SCHEMA>|http|" "${SITES_ENABLED}/${SITE}.conf"
            ${SED} -i "s|<HTTP_REDIR>|https|" "${SITES_ENABLED}/${SITE}.conf"

        else

            ${SED} -i "s|<HTTP_SCHEMA>|https|" "${SITES_ENABLED}/${SITE}.conf"
            ${SED} -i "s|<HTTP_REDIR>|http|" "${SITES_ENABLED}/${SITE}.conf"

        fi

        if [[ -n ${APP_SOCKET} ]] && [[ ${APP_SOCKET} != "null" ]]; then

            echo "Configuring site app socket ${SITES_ENABLED}/${SITE}.conf"
            ${SED} -i "s|default|${APP_SOCKET}|" "${SITES_ENABLED}/${SITE}.conf"
        fi

        if [[ -n ${APP_INDEX} ]] && [[ ${APP_INDEX} != "null" ]]; then

            echo "Configuring index ${APP_INDEX}"
            APP_INDEX_FILE=${APP_INDEX}
        fi

        ${SED} -i "s|<APP_SERVER_NAME>|${SITE}|" "${SITES_ENABLED}/${SITE}.conf"
        ${SED} -i "s|<APP_DOMAINS>|${SITE_DOMAINS}|" "${SITES_ENABLED}/${SITE}.conf"
        ${SED} -i "s|<DOCUMENT_ROOT>|${DOCUMENT_ROOT}|" "${SITES_ENABLED}/${SITE}.conf"
        ${SED} -i "s|<APP_INDEX_FILE>|${APP_INDEX_FILE}|" "${SITES_ENABLED}/${SITE}.conf"

        ${SED} -i "s|<APP_SERVER_HTTP_PORT>|${APP_SERVER_HTTP_PORT}|" "${SITES_ENABLED}/${SITE}.conf"
        ${SED} -i "s|<APP_SERVER_HTTPS_PORT>|${APP_SERVER_HTTPS_PORT}|" "${SITES_ENABLED}/${SITE}.conf"

        echo "$(hostname  -i)   ${SITE_DOMAINS}" >> /etc/hosts

    done
}

[ -f ${UPSTREAM_CONF} ] && rm -v ${UPSTREAM_CONF}
if [ ! -z ${PHP_FPM_SOCKET} ]; then

    echo -e "\nConfiguring default upstram: ${PHP_FPM_SOCKET} >> ${UPSTREAM_CONF}"
    echo "upstream default { server ${PHP_FPM_SOCKET}; }" > ${UPSTREAM_CONF}

    echo -e "\n========================================================================="
fi

if [[ ! -z ${NGINX_SITES_CUSTOM} ]]; then


    for SITES_CUSTOM in ${NGINX_SITES_CUSTOM}; do

        if [ -f ${SITES_CUSTOM} ]; then

            echo -e "\n==>> Custom APP configuration: ${NGINX_SITES_CUSTOM} "
            cp -va ${SITES_CUSTOM} ${SITES_ENABLED}

        else

            echo -e "\n==>> File configuration: ${SITES_CUSTOM} not found!"

        fi

    done

else

    site_configuration

fi
mkdir -p ${DOCUMENT_ROOT}


[ ! -d /etc/nginx/ssl ] && mkdir -p /etc/nginx/ssl/

if [ ! -f /etc/nginx/ssl/nginx.key ]; then

    echo -e "\n Generating self signed cert"
    openssl req -x509 -newkey rsa:4086 \
        -subj "/C=KG/ST=NA/O=Development/OU=DTUX/CN=dtux.org/emailAddress=diego.grassato@gmail.com" \
        -keyout "/etc/nginx/ssl/nginx.key" \
        -out "/etc/nginx/ssl/nginx.crt" \
        -days 3650 -nodes -sha256

 openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
    -extensions vpn_request_tool -keyout "${_VPN_REQUEST_TOOL_CA_KEY_FILE}" -out "${_VPN_REQUEST_TOOL_CA_CRT_FILE}" \
    -subj "${_VPN_REQUEST_TOOL_CA_SUBJECT}" \
    -config "${_VPN_REQUEST_TOOL_OPENSSL_CNF_DIR}"

    openssl dhparam -out "/etc/nginx/ssl/dhparam.pem" 2048

fi

# Execute passed CMD arguments
exec "$@"
