#!/usr/bin/env bash

echo "================================="
echo " Prepare environment to PHP-FPM. "
echo "================================="

SED=$(which sed)
function disable_module() {

    local MODULES="${@}"

    for SAPI_NAME in ${SAPI_NAMES}; do

        for MODULE in ${MODULES}; do

            local MODULES_ENABLED="/etc/php/7.0/${SAPI_NAME}/conf.d"
            local MODULE_NAME="20-${MODULE}.ini"
            local MODULE_PATH="${MODULES_ENABLED}/${MODULE_NAME}"
            if [[ -L "${MODULE_PATH}" ]] ; then
                    echo -e "\nDisabled module ${MODULE_PATH}"
                    unlink ${MODULE_PATH}
                else
                    echo -e "\n=>Module not found  ${MODULE_PATH}\n"
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

            local MODULES_AVAILABLE="/etc/php/mods-available/${MODULE}.ini"
            local MODULES_ENABLED="/etc/php/7.0/${SAPI_NAME}/conf.d"
            local MODULE_NAME="20-${MODULE}.ini"
            local MODULE_PATH="${MODULES_ENABLED}/${MODULE_NAME}"
            if [[ -s "${MODULES_AVAILABLE}" ]] && [[ ! -L "${MODULE_PATH}" ]]; then
                    echo -e "\nEnabled module ${MODULES_AVAILABLE} ${MODULE_PATH}"
                    ln -s ${MODULES_AVAILABLE} ${MODULE_PATH}
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
    echo -e "\nEnable modules all: ${PHP_FPM_ENABLE_MOD}"
    enable_module_all "${PHP_FPM_ENABLE_MOD}"
fi

# Enable cli modules
if [[ ! -z "${PHP_FPM_ENABLE_CLI_MOD}" ]]; then
    echo -e "\nEnable modules cli: ${PHP_FPM_ENABLE_CLI_MOD}"
    enable_module_cli "${PHP_FPM_CLI_DIS_MOD}"
fi

############ Disable modules ############ ############ ############
# Disable modules
if [[ ! -z ${PHP_FPM_DIS_MOD} ]]; then
    echo -e "\nDisable modules all: ${PHP_FPM_CLI_DIS_MOD}"
    disable_module_all "${PHP_FPM_DIS_MOD}"
fi

# Disable cli modules
if [[ ! -z ${PHP_FPM_CLI_DIS_MOD} ]]; then
    echo -e "\nDisable modules cli: ${PHP_FPM_CLI_DIS_MOD}"
    disable_module_cli "${PHP_FPM_CLI_DIS_MOD}"
fi

############ ############ ############ ############

export XDEBUG_INI="/etc/php/mods-available/xdebug.ini"

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
    echo -e "\nConfiguring php-fpm xdebug to ${PHP_FPM_XDEBUG_REMOTE_IP}:${PHP_FPM_XDEBUG_PORT}, state ${PHP_FPM_XDEBUG_ENABLE}"

    ${SED} -i "s@<PHP_FPM_XDEBUG_PORT>@${PHP_FPM_XDEBUG_PORT}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_FPM_XDEBUG_REMOTE_IP>@${PHP_FPM_XDEBUG_REMOTE_IP}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_FPM_XDEBUG_ENABLE>@${PHP_FPM_XDEBUG_ENABLE}@" ${XDEBUG_INI}
    ${SED} -i "s@<PHP_FPM_XDEBUG_IDE_KEY>@${PHP_FPM_XDEBUG_IDE_KEY}@" ${XDEBUG_INI}

    # Xdebug remove log
    ${SED} -i '/xdebug\.remote_log/d' ${XDEBUG_INI}
    if [[ ! -z ${PHP_FPM_XDEBUG_REMOTE_LOG_ENABLE} ]] && [[ ${PHP_FPM_XDEBUG_REMOTE_LOG_ENABLE} == 'true' ]]; then

        echo -e "\nConfiguring php-fpm xdebug to ${PHP_FPM_XDEBUG_REMOTE_IP}:${PHP_FPM_XDEBUG_PORT}, state ${PHP_FPM_XDEBUG_ENABLE}"
        echo "xdebug.remote_log=/tmp/xdebug.log" | tee -a ${XDEBUG_INI}

    fi

fi

if [ ! "${PHP_FPM_PRODUCTION}" == "true" ] ; then

    echo -e "\nConfiguring php-fpm to development"

    # PHP-FPM development settings
    ## /etc/php/7.0/fpm/php.ini
    ${SED} -i '/memory_limit = /c memory_limit = 256M' /etc/php/7.0/fpm/php.ini
    ${SED} -i '/max_execution_time = /c max_execution_time = 300' /etc/php/7.0/fpm/php.ini
    ${SED} -i '/upload_max_filesize = /c upload_max_filesize = 500M' /etc/php/7.0/fpm/php.ini
    ${SED} -i '/post_max_size = /c post_max_size = 500M' /etc/php/7.0/fpm/php.ini
    ${SED} -i '/error_log = /c error_log = \/dev\/stdout' /etc/php/7.0/fpm/php.ini
    ${SED} -i '/;always_populate_raw_post_data/c always_populate_raw_post_data = -1' /etc/php/7.0/fpm/php.ini
    ${SED} -i '/;sendmail_path/c sendmail_path = /bin/true' /etc/php/7.0/fpm/php.ini
    ## /etc/php/7.0/fpm/php-fpm.conf
    #${SED} -i '/;daemonize = /c daemonize = no' /etc/php/7.0/fpm/php-fpm.conf
    ${SED} -i '/error_log = /c error_log = \/dev\/stdout' /etc/php/7.0/fpm/php-fpm.conf
    # PHP CLI settings
    ${SED} -i '/memory_limit = /c memory_limit = 512M' /etc/php/7.0/cli/php.ini
    ${SED} -i '/max_execution_time = /c max_execution_time = 600' /etc/php/7.0/cli/php.ini
    ${SED} -i '/error_log = php_errors.log/c error_log = \/dev\/stdout' /etc/php/7.0/cli/php.ini
    ${SED} -i '/;sendmail_path/c sendmail_path = /bin/true' /etc/php/7.0/cli/php.ini
    ${SED} -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ UTC/g' /etc/php/7.0/cli/php.ini
    ${SED} -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ UTC/g' /etc/php/7.0/fpm/php.ini

fi

#Reload service
service php7.0-fpm reload

# Execute passed CMD arguments
exec "$@"
