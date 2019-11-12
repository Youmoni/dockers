#https://github.com/umpc/foundationdb/blob/docker/docker/debian/9.4/Dockerfile
FROM debian:9.5

ARG FDB_VERSION="5.2.5"
ARG FDB_DEB_REVISION="1"

ARG FDB_PKG_URL="https://www.foundationdb.org/downloads/${FDB_VERSION}/ubuntu/installers"
ARG FDB_CLIENTS_PKG="foundationdb-clients_${FDB_VERSION}-${FDB_DEB_REVISION}_amd64.deb"

ENV FDB_USER_DIRS="$FDB_USER_DIRS"
ENV FDB_UID="1000"
ENV FDB_GID="1000"

ADD $FDB_PKG_URL/$FDB_CLIENTS_PKG /tmp/$FDB_CLIENTS_PKG

RUN apt update && \
    apt install -y python && \
    apt clean
RUN dpkg -i /tmp/$FDB_CLIENTS_PKG && \
    rm /tmp/$FDB_CLIENTS_PKG

#RUN rm /var/log/foundationdb/trace.*.1.xml && \
#    for DIR in $FDB_USER_DIRS; do mv $DIR $DIR.default; done

# Install OpenJDK 1.8: https://github.com/docker-library/openjdk/blob/86918ee28d383e7af63f535a2558040dce141099/8/jdk/slim/Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
                bzip2 \
                unzip \
                xz-utils \
        && rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
                echo '#!/bin/sh'; \
                echo 'set -e'; \
                echo; \
                echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
        } > /usr/local/bin/docker-java-home \
        && chmod +x /usr/local/bin/docker-java-home

# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home

ENV JAVA_VERSION 8u181
ENV JAVA_DEBIAN_VERSION 8u181-b13-1~deb9u1

# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1

RUN set -ex; \
        \
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
        if [ ! -d /usr/share/man/man1 ]; then \
                mkdir -p /usr/share/man/man1; \
        fi; \
        \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                openjdk-8-jdk-headless="$JAVA_DEBIAN_VERSION" \
                ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
        ; \
        rm -rf /var/lib/apt/lists/*; \
        \
# verify that "docker-java-home" returns what we expect
        [ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
        \
# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
        update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
# ... and verify that it actually worked for one of the alternatives we care about
        update-alternatives --query java | grep -q 'Status: manual'

# see CA_CERTIFICATES_JAVA_VERSION notes above
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure