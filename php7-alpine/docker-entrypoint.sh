#!/usr/bin/env sh

echo "======================================="
echo " Prepare environment to PHP Alpine.    "
echo "======================================="


SED=$(which sed)
############ ############ ############ ############

export XDEBUG_INI="/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"

if [[ -s ${XDEBUG_INI} ]]; then

############ XDEBUG VARIABLES ############ ############ ############
    if [[ -z ${PHP_XDEBUG_PORT} ]]; then
        export PHP_XDEBUG_PORT=9000
    fi

    if [[ -z ${PHP_XDEBUG_REMOTE_IP} ]]; then
        export PHP_XDEBUG_REMOTE_IP="127.0.0.1"
    fi

    if [[ -z ${PHP_XDEBUG_ENABLE} ]]; then
        export PHP_XDEBUG_ENABLE=1
    fi

    if [[ -z ${PHP_XDEBUG_IDE_KEY} ]]; then
        export PHP_XDEBUG_IDE_KEY=PHPSTORM
    fi

    if [[ -z ${PHP_XDEBUG_PROFILER_ENABLE} ]]; then
        export PHP_XDEBUG_PROFILER_ENABLE=1
    fi

    if [[ -z ${PHP_XDEBUG_PROFILER_OUTPUT_DIR} ]]; then
        export PHP_XDEBUG_PROFILER_OUTPUT_DIR="/tmp"
    fi

    if [[ -z ${PHP_XDEBUG_PROFILER_OUTPUT_NAME} ]]; then
        export PHP_XDEBUG_PROFILER_OUTPUT_NAME="cachegrind.out.%p"
    fi

    if [[ -z ${PHP_XDEBUG_REMOTE_LOG} ]]; then
        export PHP_XDEBUG_REMOTE_LOG="/tmp/php-xdebug.log"
    fi

############ XDEBUG CONFIGURATIONS ############ ############ ############
    echo -e "\n#### Configuring php-fpm xdebug to ${PHP_XDEBUG_REMOTE_IP}:${PHP_XDEBUG_PORT}, state ${PHP_XDEBUG_ENABLE}"

    ${SED} -i "s@<PHP_XDEBUG_PORT>@${PHP_XDEBUG_PORT}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_XDEBUG_REMOTE_IP>@${PHP_XDEBUG_REMOTE_IP}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_XDEBUG_ENABLE>@${PHP_XDEBUG_ENABLE}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_XDEBUG_IDE_KEY>@${PHP_XDEBUG_IDE_KEY}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_XDEBUG_PROFILER_ENABLE>@${PHP_XDEBUG_PROFILER_ENABLE}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_XDEBUG_PROFILER_OUTPUT_DIR>@${PHP_XDEBUG_PROFILER_OUTPUT_DIR}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_XDEBUG_PROFILER_OUTPUT_NAME>@${PHP_XDEBUG_PROFILER_OUTPUT_NAME}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_XDEBUG_REMOTE_LOG>@${PHP_XDEBUG_REMOTE_LOG}@" ${XDEBUG_INI}

    # Xdebug remove log
    ${SED} -i '/xdebug\.remote_log/d' ${XDEBUG_INI}
    if [[ ! -z ${PHP_XDEBUG_REMOTE_LOG_ENABLE} ]] && [[ ${PHP_XDEBUG_REMOTE_LOG_ENABLE} == 'true' ]]; then

        echo -e "#### Configuring php-fpm xdebug to ${PHP_XDEBUG_REMOTE_IP}:${PHP_XDEBUG_PORT}, state ${PHP_XDEBUG_ENABLE}"
        echo "xdebug.remote_log=/tmp/xdebug.log" | tee -a ${XDEBUG_INI}

    fi

fi

if [[ -z ${PHP_FPM_PORT} ]]; then
    export PHP_FPM_PORT=9000
fi

${SED} -i -e "s/listen.*/listen = [::]:${PHP_FPM_PORT}/" /usr/local/etc/php-fpm.d/zz-docker.conf

if [[ ${PHP_PRODUCTION} == "true" ]]; then

    rm /usr/local/etc/php/conf.d/php.ini

fi

if [[ ! ${PHP_OPCACHE_ENABLE} == "true" ]]; then

    rm /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

fi


if [[ ! ${PHP_XDEBUG_ENABLE} == "on" ]]; then

    rm ${XDEBUG_INI}

fi
# Execute passed CMD arguments
exec "$@"
