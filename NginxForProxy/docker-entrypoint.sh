#!/usr/bin/env bash
set -e
#Paramétre de PureFTPD
groupadd ftpgroup
useradd -g ftpgroup -d /dev/null -s /etc ftpuser
pure-pw useradd $FTP_USERNAME -u ftpuser /var/www
echo $FTP_PASSWORD | pure-pw passwd $FTP_USERNAME
pure-pw mkdb
exec /bin/bash
