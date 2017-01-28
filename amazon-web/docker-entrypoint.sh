#!/usr/bin/env bash

echo "================================="
echo " Prepare environment to PHP .    "
echo "================================="

SED=$(which sed)
CP=$(which cp)


############ ############ ############ ############
${CP} -v ${PHP_BASE}/20-xdebug.ini /etc/php-7.0.d/20-xdebug.ini
export XDEBUG_INI="/etc/php-7.0.d/20-xdebug.ini"

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
    echo -e "\n#### Configuring php xdebug to ${PHP_XDEBUG_REMOTE_IP}:${PHP_XDEBUG_PORT}, state ${PHP_XDEBUG_ENABLE}\n"

    ${SED} -i "s@<PHP_XDEBUG_PORT>@${PHP_XDEBUG_PORT}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_XDEBUG_REMOTE_IP>@${PHP_XDEBUG_REMOTE_IP}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_XDEBUG_ENABLE>@${PHP_XDEBUG_ENABLE}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_XDEBUG_IDE_KEY>@${PHP_XDEBUG_IDE_KEY}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_XDEBUG_REMOTE_LOG>@${PHP_XDEBUG_REMOTE_LOG}@" ${XDEBUG_INI}

    # Xdebug profilling
    if [[  ${PHP_XDEBUG_PROFILER_ENABLE} == '1' ]] || [[ ${PHP_XDEBUG_PROFILER_ENABLE} == 'on' ]]; then

        ${SED} -i "s@<PHP_XDEBUG_PROFILER_ENABLE>@${PHP_XDEBUG_PROFILER_ENABLE}@" ${XDEBUG_INI}
        ${SED} -i "s@<PHP_XDEBUG_PROFILER_OUTPUT_DIR>@${PHP_XDEBUG_PROFILER_OUTPUT_DIR}@" ${XDEBUG_INI}
        ${SED} -i "s@<PHP_XDEBUG_PROFILER_OUTPUT_NAME>@${PHP_XDEBUG_PROFILER_OUTPUT_NAME}@" ${XDEBUG_INI}

    fi

fi

if [ ! "${PHP_PRODUCTION}" == "on" ] ; then

    echo -e "\n#### Configuring php to development mode\n"
    # PHP development settings
    ${CP} -v ${PHP_BASE}/10-php.ini /etc/php-7.0.d/1-php.ini
    ${CP} -v ${PHP_BASE}/10-opcache.ini /etc/php-7.0.d/10-opcache.ini

fi

# Execute passed CMD arguments
exec "$@"
