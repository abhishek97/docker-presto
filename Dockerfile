FROM openjdk:8u212-jdk-alpine3.9

MAINTAINER Jiayu Liu <etareduce@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
  && pip install virtualenv \
  && rm -rf /var/cache/apk/*

ADD https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.230/presto-server-0.230.tar.gz \
    /tmp/presto.tar.gz

RUN mkdir -p /opt/presto &&\
    tar -zxvf /tmp/presto.tar.gz -C /opt/presto &&\
    rm /tmp/presto.tar.gz

ENV HOME /opt/presto/presto-server-0.230

WORKDIR $HOME

# copy default set of config
COPY config/ $HOME/etc/
# adding the config mounting point
VOLUME $HOME/etc/
# adding the data mounting point
VOLUME $HOME/data/

EXPOSE 8080

CMD ["/opt/presto/presto-server-0.230/bin/launcher", "run"]
