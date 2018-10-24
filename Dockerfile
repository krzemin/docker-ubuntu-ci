FROM ubuntu:18.04
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

RUN npm install -g elm@0.18.0 elm-github-install newman

RUN apt-get install -y build-essential chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev \
 && export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64" \
 && cd /tmp \
 && wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/$PHANTOM_JS.tar.bz2 \
 && tar xvjf $PHANTOM_JS.tar.bz2 \
 && mv $PHANTOM_JS /usr/local/share \
 && ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin \
 && cd $OLDPWD \
 && rm -fr /tmp/phantom*

RUN wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/5.2.0/flyway-commandline-5.2.0-linux-x64.tar.gz -O /tmp/flyway.tar.gz \
 && tar -zxvf /tmp/flyway.tar.gz -C /usr/local/share \
 && ln -s /usr/local/share/flyway-5.2.0/flyway /usr/local/bin/flyway \
 && rm -f /tmp/flyway.tar.gz

RUN wget https://github.com/antew/node-elm-compiler/releases/download/elm-make-files/elm-make.linux.x64 -O /usr/bin/elm-make-rts && chmod +x /usr/bin/elm-make-rts

