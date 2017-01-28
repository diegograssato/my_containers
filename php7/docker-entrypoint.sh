#!/usr/bin/env bash

echo "================================="
echo " Prepare environment to PHP .    "
echo "================================="

SED=$(which sed)
function disable_module_all(){

    phpdismod -s ALL "${@}"

}

function disable_module_cli(){

    phpdismod -s cli "${@}"

}

function enable_module_all(){

    phpenmod -s ALL "${@}"

}

function enable_module_cli(){

    phpenmod -s cli "${@}"

}
############ Enable modules ############ ############ ############

# Enable modules
if [[ ! -z "${PHP_ENABLE_MOD}" ]]; then
    echo -e "\n#### Enable modules all: ${PHP_ENABLE_MOD}"
    enable_module_all "${PHP_ENABLE_MOD}"
fi

# Enable cli modules
if [[ ! -z "${PHP_ENABLE_CLI_MOD}" ]]; then
    echo -e "\n#### Enable modules cli: ${PHP_ENABLE_CLI_MOD}"
    enable_module_cli "${PHP_CLI_DIS_MOD}"
fi

if [ ! -z ${PHP_FPM_POOL_FILE} ] && [ -s ${PHP_FPM_POOL_FILE} ];then

    echo -e "\n#### Copy file : ${PHP_FPM_POOL_FILE} to ${PHP_BASE}/fpm/pool.d"
    cp -a ${PHP_FPM_POOL_FILE} ${PHP_BASE}/fpm/pool.d/

fi

if [ ! -z ${PHP_FPM_POOL_FOLDER} ] && [ -d ${PHP_FPM_POOL_FILE} ];then

    echo -e "\n#### Copy all files in folder : ${PHP_FPM_POOL_FOLDER} to ${PHP_BASE}/fpm/pool.d"
    cp -a ${PHP_FPM_POOL_FILE}/* ${PHP_BASE}/fpm/pool.d/

fi

if [ ! -z ${PHP_FPM_CONFIG_FILE} ] && [ -d ${PHP_FPM_CONFIG_FILE} ];then

    echo -e "\n#### Copy file : ${PHP_FPM_CONFIG_FILE} to ${PHP_BASE}/fpm/"
    cp -a ${PHP_FPM_CONFIG_FILE} ${PHP_BASE}/fpm/

fi
############ Disable modules ############ ############ ############
# Disable modules
if [[ ! -z ${PHP_DIS_MOD} ]]; then
    echo -e "\n#### Disable modules all: ${PHP_DIS_MOD}"
    disable_module_all "${PHP_DIS_MOD}"
fi

# Disable cli modules
if [[ ! -z ${PHP_CLI_DIS_MOD} ]]; then
    echo -e "\n#### Disable modules cli: ${PHP_CLI_DIS_MOD}"
    disable_module_cli "${PHP_CLI_DIS_MOD}"
fi

############ ############ ############ ############

export XDEBUG_INI="${PHP_BASE}/mods-available/xdebug.ini"

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

if [ ! "${PHP_PRODUCTION}" == "true" ] ; then

    echo -e "#### Configuring php-fpm to development"

    # PHP-FPM development settings
    ## ${PHP_BASE}/fpm/php.ini
    ${SED} -i '/memory_limit = /c memory_limit = 1024M' ${PHP_BASE}/fpm/php.ini
    ${SED} -i '/max_execution_time = /c max_execution_time = 800' ${PHP_BASE}/fpm/php.ini
    ${SED} -i '/upload_max_filesize = /c upload_max_filesize = 1024M' ${PHP_BASE}/fpm/php.ini
    ${SED} -i '/post_max_size = /c post_max_size = 800M' ${PHP_BASE}/fpm/php.ini
    ${SED} -i '/error_log = /c error_log = \/dev\/stdout' ${PHP_BASE}/fpm/php.ini
    ${SED} -i '/;always_populate_raw_post_data/c always_populate_raw_post_data = -1' ${PHP_BASE}/fpm/php.ini
    ${SED} -i '/;sendmail_path/c sendmail_path = /bin/true' ${PHP_BASE}/fpm/php.ini
    ## ${PHP_BASE}/fpm/php-fpm.conf
    #${SED} -i '/;daemonize = /c daemonize = no' ${PHP_BASE}/fpm/php-fpm.conf
    ${SED} -i '/error_log = /c error_log = \/dev\/stdout' ${PHP_BASE}/fpm/php-fpm.conf
    ${SED} -i '/display_errors = /c error_log = On' ${PHP_BASE}/fpm/php.ini
    ${SED} -i '/display_startup_errors = /c display_startup_errors = On' ${PHP_BASE}/fpm/php.ini
    # PHP CLI settings
    ${SED} -i '/memory_limit = /c memory_limit = -1' ${PHP_BASE}/cli/php.ini
    ${SED} -i '/max_execution_time = /c max_execution_time = 800' ${PHP_BASE}/cli/php.ini
    ${SED} -i '/error_log = php_errors.log/c error_log = \/dev\/stdout' ${PHP_BASE}/cli/php.ini
    ${SED} -i '/;sendmail_path/c sendmail_path = /bin/true' ${PHP_BASE}/cli/php.ini
    ${SED} -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ UTC/g' ${PHP_BASE}/cli/php.ini
    ${SED} -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ UTC/g' ${PHP_BASE}/fpm/php.ini

fi

if [[ ${PHP_FPM_ENABLED} == "true" ]]; then


    echo -e "\n#### Using php-fpm: true"
    #Reload service
    #service php7.1-fpm reload
    if [[ -f /usr/sbin/php-fpm7.1 ]]; then

        /usr/sbin/php-fpm7.1 -F

    elif [[ -f /usr/sbin/php-fpm7.0 ]]; then

        /usr/sbin/php-fpm7.0 -F

    fi
fi

# Execute passed CMD arguments
exec "$@"
