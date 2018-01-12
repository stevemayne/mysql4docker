FROM ubuntu:12.04
MAINTAINER Steve Mayne <steve.mayne@gmail.com>

RUN apt-get update && apt-get install -q -y \
  bison \
  build-essential \ 
  checkinstall \
  libncurses5-dev 

RUN groupadd -r mysql && useradd -r -g mysql mysql

ADD mysql-4.1.25.tar.gz /usr/local/src

ENV PATH /usr/local/mysql/bin:$PATH
ENV MYSQLDATA /usr/local/mysql/var
VOLUME /usr/local/mysql/var

COPY buildmysql4.sh /tmp/buildmysql4.sh
RUN chmod +x /tmp/buildmysql4.sh
RUN /tmp/buildmysql4.sh

FROM ubuntu:12.04

COPY --from=0 /usr/local/src/mysql-4.1.25/mysql_4.1.25-1_amd64.deb /tmp/mysql_4.1.25-1_amd64.deb
RUN dpkg -f /tmp/mysql_4.1.25-1_amd64.deb && rm /tmp/mysql_4.1.25-1_amd64.deb

COPY my.cnf /etc/my.cnf

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld_safe"]
