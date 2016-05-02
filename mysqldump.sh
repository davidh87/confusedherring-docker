#!/bin/bash

NOW=`date +"%Y%m%d-%H%M%S"`

file=$HOME/dbbackups/$NOW.sql
echo "Backing up all DBs to $file"
docker run -i --link mariadb:mysql --rm mariadb sh -c 'exec mysqldump -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -A' > $file
