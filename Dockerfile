FROM ubuntu:18.10
MAINTAINER Piotr Krzemiński (pio.krzeminski@gmail.com)

RUN apt-get update && apt-get install -y dirmngr ca-certificates wget curl jq

RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 2EE0EA64E40A89B84B2DF73499E82A75642AC823 \ 
 && apt-get update

RUN apt-get install -y postgresql-10 \
 && echo "local all postgres trust" > /etc/postgresql/10/main/pg_hba.conf \
 && echo "host all postgres 127.0.0.1/32 trust" >> /etc/postgresql/10/main/pg_hba.conf

RUN apt-get install -y openjdk-11-jdk-headless && update-java-alternatives -s java-1.11.0-openjdk-amd64 && update-ca-certificates -f

RUN apt-get install -y sbt nodejs npm

#RUN apt-get install -y docker.io

RUN curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose

RUN wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/5.2.4/flyway-commandline-5.2.4-linux-x64.tar.gz | tar xvz && ln -s `pwd`/flyway-5.2.4/flyway /usr/local/bin 

RUN apt-get clean && apt-get autoclean && rm -fr /tmp/* /usr/share/man* /usr/share/doc*
