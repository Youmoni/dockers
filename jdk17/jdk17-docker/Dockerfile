FROM adoptopenjdk/openjdk17:slim

RUN apt-get update; apt-get install -y bash gawk sed grep bc coreutils dnsutils apt-transport-https gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg > /var/tmp/docker.key; apt-key add /var/tmp/docker.key; rm /var/tmp/docker.key
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable"; apt-get update;  apt-get install -y docker-ce-cli
RUN addgroup --gid 119 kuriren-docker;adduser --uid 1001 docker; usermod -aG kuriren-docker docker
