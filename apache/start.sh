#!/usr/bin/env bash
set -e
# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2*.pid
echo "$(hostname -I)  localhost apache2" >> /etc/hosts
source /etc/apache2/envvars
apachectl configtest 
exec apache2 -DFOREGROUND -DAPACHE_LOCK_DIR
