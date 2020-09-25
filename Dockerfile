
FROM debian:stable as java11-builder

RUN apt update -qq &&\
    apt install wget -y

RUN wget https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz -P /srv &&\
    mkdir /srv/jdk &&\
    tar -xvvf /srv/openjdk-11.0.1_linux-x64_bin.tar.gz --strip-components=1 -C /srv/jdk

ENV PATH $PATH:/srv/jdk/bin

RUN jlink --module-path /srv/jdk/jmods \
	--compress=2 \
    	--add-modules jdk.jfr,jdk.management.agent,java.base,java.logging,java.xml,jdk.unsupported,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument \
    	--no-header-files \
    	--no-man-pages \
	--output /srv/jre


FROM debian:stable-slim
USER root

RUN apt-get update &&\ 
	apt-get install curl openssl -y &&\
	apt install gettext-base procps -y

RUN rm -rf /var/lib/apt/lists/*

COPY --from=java11-builder /srv/jre /usr/share/java

ENV PATH $PATH:/usr/share/java/bin
ENV JAVA_HOME /usr/share/java

ENV PATH $PATH:$JAVA_HOME/bin
ENV KAFKA_HOME=/opt/kafka
ENV KAFKA_VERSION=2.4.0
ENV SCALA_VERSION=2.12

# Downloading/extracting Apache Kafka
RUN curl -O https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && mkdir $KAFKA_HOME \
    && tar xvfz kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C $KAFKA_HOME --strip-components=1 \
    && rm -f kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz*

WORKDIR $KAFKA_HOME

ENV PATH $PATH:$KAFKA_HOME/bin

COPY scripts/* ${KAFKA_HOME}/

ARG UNAME=kafka
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID -o $UNAME && \
    useradd -r -m -u $UID -g $GID $UNAME
RUN chown -R "$UNAME:$UNAME" $KAFKA_HOME
