#!/bin/bash
set -e

if [ "$1" = 'mysqld_safe' ]; then
    chown -R mysql "$MYSQLDATA"
	
    if [ -z "$(ls -A "$MYSQLDATA")" ]; then
        mysql_install_db --user=mysql
    fi
fi

exec "$@"
