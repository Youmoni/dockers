FROM adoptopenjdk/openjdk8:alpine-slim

MAINTAINER Odd Möller "https://github.com/odd"

RUN apk add --no-cache bash
#RUN apk add --update --no-cache bash gawk sed grep bc coreutils bind-tools

# Set environment
ENV JAVA_HOME /opt/jdk
ENV PATH /opt/jdk/bin:${PATH}