#!/bin/bash
set -e

if [ "$1" = 'mysqld_safe' ]; then
    chown -R mysql "$MYSQLDATA"
	
    if [ -z "$(ls -A "$MYSQLDATA")" ]; then
    	echo "Initializing database..."
        mysql_install_db --user=mysql
        
        if [ "$MYSQL_ROOT_PASSWORD" == "" ]; then
			echo >&2 'error: database is uninitialized and password option is not specified '
			echo >&2 '  You need to specify MYSQL_ROOT_PASSWORD'
			exit 1
		else
        	echo "Setting root password..."

        	mysqld_safe --skip-networking &
			pid="$!"
			
			mysql=( mysql --protocol=socket -uroot )

			for i in {30..0}; do
				if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
					break
				fi
				echo 'MySQL init process in progress...'
				sleep 1
			done

			if [ "$i" = 0 ]; then
				echo >&2 'MySQL init process failed.'
				exit 1
			fi

"${mysql[@]}" <<-EOSQL
	SET @@SESSION.SQL_LOG_BIN=0;
	DELETE FROM mysql.user ;
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
	FLUSH PRIVILEGES ;
EOSQL

			if ! kill -s TERM "$pid" || ! wait "$pid"; then
				echo >&2 'MySQL init process failed.'
				exit 1
			fi
        fi
    fi
fi

exec "$@"
