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
COPY my.cnf /etc/my.cnf

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld_safe"]
