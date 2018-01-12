#!/bin/sh

cd /usr/local/src/mysql-4.1.25/
./configure --prefix=/usr/local/mysql
make
mkdir /usr/local/mysql
mkdir /usr/local/mysql/include
mkdir /usr/local/mysql/include/mysql
mkdir /usr/local/mysql/lib
mkdir /usr/local/mysql/lib/mysql
mkdir /usr/local/mysql/share
mkdir /usr/local/mysql/man
mkdir /usr/local/mysql/mysql-test
checkinstall -y
cp support-files/my-medium.cnf /etc/my.cnf
cp support-files/mysql.server /etc/init.d/mysql
chmod 755 /etc/init.d/mysql
chkconfig mysql on
cd /usr/local/mysql/
chown -R root .
chown -R mysql var
chgrp -R mysql .
#rm -rf /usr/local/src/mysql-4.1.25
