FROM ubuntu:12.04
MAINTAINER Steve Mayne <steve.mayne@gmail.com>

RUN apt-get update && apt-get install -q -y \
  bison \
  build-essential \ 
  checkinstall \
  libncurses5-dev 

RUN groupadd -r mysql && useradd -r -g mysql mysql

#ADD https://www.pccc.com/downloads/apache/current/mysql-4.1.25.tar.gz /tmp/mysql-4.1.24.tar
#RUN tar -xvf /tmp/mysql-4.1.24.tar --directory=/usr/local/src

ADD mysql-4.1.25.tar.gz /usr/local/src

ENV PATH /usr/local/mysql/bin:$PATH
ENV MYSQLDATA /usr/local/mysql/var
VOLUME /usr/local/mysql/var

COPY buildmysql4.sh /tmp/buildmysql4.sh
RUN /tmp/buildmysql4.sh

COPY docker-entrypoint.sh /

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld_safe"]
