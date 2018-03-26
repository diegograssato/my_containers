#!/bin/bash

echo "=========================================="
echo " Prepare saltstack ${SALT_USE}.              "
echo "=========================================="

# Variables from environement
: "${SALT_USE:=master}"
: "${SALT_NAME:=master}"
: "${LOG_LEVEL:=info}"
: "${OPTIONS:=}"
: "${SALT_ADMIN_USER:=saltuser}"
: "${SALT_ADMIN_PASS:=saltuser}"

#used in minion only
: "${SALT_MASTER_HOST:=master}"

# Get salt hostname
SALT_HOSTNAME=$(hostname -s)

# Set salt grains
if [[ ! -z "${SALT_GRAINS}" ]]; then

  echo "INFO: Set grains on ${SALT_NAME} to: ${SALT_GRAINS}"
  echo "${SALT_GRAINS}" > /etc/salt/grains

fi

SALT_API=$(which salt-api)
if [[ ! -z "${SALT_API}" && ${SALT_USE} == "master" ]]; then

  echo "INFO: Starting ${SALT_API} with log level ${LOG_LEVEL} with hostname ${SALT_HOSTNAME}"
  ${SALT_API} --config-dir="${SALT_CONFIG}" -d --log-level="${LOG_LEVEL}"

fi

function salt_clean() {
  
  salt  '*'  test.ping > all_hosts

  cat all_hosts | grep return -B 1 | grep -v 'return' | cut -d':' -f1 > salt_error_hosts
 
for i in $(cat salt_error_hosts); do

    # for delete the authed key 
    salt-key -d $i -y;
    # for delete the unauthed key , sometime it is a must 
    salt-key -d $i -y;

    # delete the pem  file
    if [[ -f /etc/salt/pki/master/minions/%i ]]; then
      rm -f /etc/salt/pki/master/minions/$i
    fi

done

}

SALT_DAEMON=$(which "salt-${SALT_USE}")
# Set minion id
  echo "${SALT_HOSTNAME}" > /etc/salt/minion_id
# Start salt-$SALT_USE 
if [[ ${SALT_USE} == "master" ]]; then
  
  cat << EOF > /etc/salt/minion
master: 127.0.0.1
log_level: ${LOG_LEVEL}
EOF

  export -f salt_clean
  # Create a default user
  SALT_PASS=$(openssl passwd -1 "${SALT_ADMIN_PASS}")
  useradd -m -s /bin/bash -g users -G sudo,ssh -p "${SALT_PASS}" "${SALT_ADMIN_USER}"

  #service salt-minion start 
else
  cat << EOF > /etc/salt/minion
master: ${SALT_MASTER_HOST}
log_level: ${LOG_LEVEL}

EOF

fi

# Generate autosigne certificate
[[ ! -d "/etc/salt/pki" ]] && mkdir -p "/etc/salt/pki/minion"
salt-call tls.create_self_signed_cert

echo "INFO: Starting ${SALT_DAEMON} with log level ${LOG_LEVEL} with hostname ${SALT_HOSTNAME}"
${SALT_DAEMON} --config-dir="${SALT_CONFIG}" --log-level="${LOG_LEVEL}" "${OPTIONS}"

# check
# salt-call key.finger --local
# salt-key --list all
# salt '*' test.ping
# Apply configurations
#salt '*' state.apply
