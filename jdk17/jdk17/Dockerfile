FROM adoptopenjdk/openjdk11:alpine-slim

MAINTAINER Youmoni "https://www.youmoni.com"

RUN apk add --no-cache bash
#RUN apk add --update --no-cache bash gawk sed grep bc coreutils bind-tools

# Set environment
ENV JAVA_HOME /opt/jdk
ENV PATH /opt/jdk/bin:${PATH}