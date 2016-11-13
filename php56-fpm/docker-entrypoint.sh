#!/usr/bin/env bash

echo "================================="
echo " Prepare environment to PHP-FPM. "
echo "================================="

SED=$(which sed)
PHP_BASE="/etc/php5"
function disable_module() {

    local MODULES="${@}"

    for SAPI_NAME in ${SAPI_NAMES}; do

        for MODULE in ${MODULES}; do

            local MODULES_ENABLED="${PHP_BASE}/${SAPI_NAME}/conf.d"
            local MODULE_NAME="20-${MODULE}.ini"
            local MODULE_PATH="${MODULES_ENABLED}/${MODULE_NAME}"
            if [[ -L "${MODULE_PATH}" ]] ; then
                    echo -e "=> Disabled module: ${MODULE_PATH}"
                    unlink ${MODULE_PATH}
                else
                    echo -e "=> Module not found:  ${MODULE_PATH}"
            fi

        done
    done

}


function disable_module_all(){

    export SAPI_NAMES="cli fpm"
    disable_module "${@}"

}

function disable_module_cli(){

    export SAPI_NAMES="cli"
    disable_module "${@}"

}

############ ############ ############ ############

function enable_module() {

    local MODULES="${@}"

    for SAPI_NAME in ${SAPI_NAMES}; do

        for MODULE in ${MODULES}; do

            local MODULES_AVAILABLE="${PHP_BASE}/mods-available/${MODULE}.ini"
            local MODULES_ENABLED="${PHP_BASE}/${SAPI_NAME}/conf.d"
            local MODULE_NAME="20-${MODULE}.ini"
            local MODULE_PATH="${MODULES_ENABLED}/${MODULE_NAME}"
            if [[ -s "${MODULES_AVAILABLE}" ]] && [[ ! -L "${MODULE_PATH}" ]]; then
                    echo -e "=> Enabled module ${MODULE_PATH}"
                    ln -s ${MODULES_AVAILABLE} ${MODULE_PATH}
            else

                if [[ -L "${MODULE_PATH}" ]]; then

                    echo -e "=> Module enabled:  ${MODULE_PATH}"

                else

                    echo -e "=> Module not found:  ${MODULES_AVAILABLE}"

                fi

            fi

        done
    done

}

function enable_module_all(){

    export SAPI_NAMES="cli fpm"
    enable_module "${@}"

}

function enable_module_cli(){

    export SAPI_NAMES="cli"
    enable_module "${@}"

}
############ Enable modules ############ ############ ############

# Enable modules
if [[ ! -z "${PHP_FPM_ENABLE_MOD}" ]]; then
    echo -e "\n#### Enable modules all: ${PHP_FPM_ENABLE_MOD}"
    enable_module_all "${PHP_FPM_ENABLE_MOD}"
fi

# Enable cli modules
if [[ ! -z "${PHP_FPM_ENABLE_CLI_MOD}" ]]; then
    echo -e "\n#### Enable modules cli: ${PHP_FPM_ENABLE_CLI_MOD}"
    enable_module_cli "${PHP_FPM_CLI_DIS_MOD}"
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
if [[ ! -z ${PHP_FPM_DIS_MOD} ]]; then
    echo -e "\n#### Disable modules all: ${PHP_FPM_DIS_MOD}"
    disable_module_all "${PHP_FPM_DIS_MOD}"
fi

# Disable cli modules
if [[ ! -z ${PHP_FPM_CLI_DIS_MOD} ]]; then
    echo -e "\n#### Disable modules cli: ${PHP_FPM_CLI_DIS_MOD}"
    disable_module_cli "${PHP_FPM_CLI_DIS_MOD}"
fi

############ ############ ############ ############

export XDEBUG_INI="${PHP_BASE}/mods-available/xdebug.ini"

if [[ -s ${XDEBUG_INI} ]]; then

############ XDEBUG VARIABLES ############ ############ ############
    if [[ -z ${PHP_FPM_XDEBUG_PORT} ]]; then
        export PHP_FPM_XDEBUG_PORT=9000
    fi

    if [[ -z ${PHP_FPM_XDEBUG_REMOTE_IP} ]]; then
        export PHP_FPM_XDEBUG_REMOTE_IP=127.0.0.1
    fi

    if [[ -z ${PHP_FPM_XDEBUG_ENABLE} ]]; then
        export PHP_FPM_XDEBUG_ENABLE=off
    fi

    if [[ -z ${PHP_FPM_XDEBUG_IDE_KEY} ]]; then
        export PHP_FPM_XDEBUG_IDE_KEY=PHPSTORM
    fi

############ XDEBUG CONFIGURATIONS ############ ############ ############
    echo -e "\n#### Configuring php-fpm xdebug to ${PHP_FPM_XDEBUG_REMOTE_IP}:${PHP_FPM_XDEBUG_PORT}, state ${PHP_FPM_XDEBUG_ENABLE}"

    ${SED} -i "s@<PHP_FPM_XDEBUG_PORT>@${PHP_FPM_XDEBUG_PORT}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_FPM_XDEBUG_REMOTE_IP>@${PHP_FPM_XDEBUG_REMOTE_IP}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_FPM_XDEBUG_ENABLE>@${PHP_FPM_XDEBUG_ENABLE}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_FPM_XDEBUG_IDE_KEY>@${PHP_FPM_XDEBUG_IDE_KEY}@" ${XDEBUG_INI}

    # Xdebug remove log
    ${SED} -i '/xdebug\.remote_log/d' ${XDEBUG_INI}
    if [[ ! -z ${PHP_FPM_XDEBUG_REMOTE_LOG_ENABLE} ]] && [[ ${PHP_FPM_XDEBUG_REMOTE_LOG_ENABLE} == 'true' ]]; then

        echo -e "#### Configuring php-fpm xdebug to ${PHP_FPM_XDEBUG_REMOTE_IP}:${PHP_FPM_XDEBUG_PORT}, state ${PHP_FPM_XDEBUG_ENABLE}"
        echo "xdebug.remote_log=/tmp/xdebug.log" | tee -a ${XDEBUG_INI}

    fi

fi

if [ ! "${PHP_FPM_PRODUCTION}" == "true" ] ; then

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
    ${SED} -i '/display_errors = /c error_log = On' ${PHP_BASE}/fpm/php-fpm.conf
    ${SED} -i '/display_startup_errors = /c display_startup_errors = On' ${PHP_BASE}/fpm/php-fpm.conf
    # PHP CLI settings
    ${SED} -i '/memory_limit = /c memory_limit = -1' ${PHP_BASE}/cli/php.ini
    ${SED} -i '/max_execution_time = /c max_execution_time = 800' ${PHP_BASE}/cli/php.ini
    ${SED} -i '/error_log = php_errors.log/c error_log = \/dev\/stdout' ${PHP_BASE}/cli/php.ini
    ${SED} -i '/;sendmail_path/c sendmail_path = /bin/true' ${PHP_BASE}/cli/php.ini
    ${SED} -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ UTC/g' ${PHP_BASE}/cli/php.ini
    ${SED} -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ UTC/g' ${PHP_BASE}/fpm/php.ini

fi

#Reload service
service php5-fpm reload

# Execute passed CMD arguments
exec "$@"
