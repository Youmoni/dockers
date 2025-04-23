FROM ubuntu/jre:edge

RUN set -o errexit -o nounset \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
        binutils \
        ca-certificates \
        curl \
        fontconfig \
        locales \
        p11-kit \
        tzdata \
        unzip \
        wget \
        \
        gcc \
        libc-dev \
        libz-dev \
        zlib1g-dev \
    && rm --recursive --force /var/lib/apt/lists/* \

ENV JAVA_HOME=/opt/java/graalvm
ENV JAVA_VERSION=22.0.2
RUN set -o errexit -o nounset \
    && mkdir /opt/java \
    \
    && echo "Downloading GraalVM" \
    && GRAALVM_AMD64_DOWNLOAD_SHA256=ebac1dd96a5e0fbcd1dd9804fa58815f146390a40aae966f02a8c26d1974364f \
    && GRAALVM_AARCH64_DOWNLOAD_SHA256=28ca4c815fa68b86141d9dcf1a46c1f58f74dead41de9042de1202337bb014d9 \
    && ARCHITECTURE=$(dpkg --print-architecture) \
    && if [ "${ARCHITECTURE}" = "amd64" ]; then GRAALVM_ARCHITECTURE=linux-x64; fi \
    && if [ "${ARCHITECTURE}" = "arm64" ]; then GRAALVM_ARCHITECTURE=linux-aarch64; fi \
    && GRAALVM_PKG=https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${JAVA_VERSION}/graalvm-community-jdk-${JAVA_VERSION}_${GRAALVM_ARCHITECTURE}_bin.tar.gz \
    && wget --no-verbose --output-document=graalvm.tar.gz "${GRAALVM_PKG}" \
    \
    && echo "Checking GraalVM download hash" \
    && if [ "${ARCHITECTURE}" = "amd64" ]; then GRAALVM_DOWNLOAD_SHA256="${GRAALVM_AMD64_DOWNLOAD_SHA256}"; fi \
    && if [ "${ARCHITECTURE}" = "arm64" ]; then GRAALVM_DOWNLOAD_SHA256="${GRAALVM_AARCH64_DOWNLOAD_SHA256}"; fi \
    && echo "${GRAALVM_DOWNLOAD_SHA256} *graalvm.tar.gz" | sha256sum --check - \
    \
    && echo "Installing GraalVM" \
    && tar --extract --gunzip --file graalvm.tar.gz \
    && rm graalvm.tar.gz \
    && mv graalvm-* "${JAVA_HOME}" \
    && for bin in "$JAVA_HOME/bin/"*; do \
        base="$(basename "$bin")"; \
        [ ! -e "/usr/bin/$base" ]; \
        update-alternatives --install "/usr/bin/${base}" "${base}" "${bin}" 1; \
    done \
    \
    && echo "Testing GraalVM installation" \
    && java --version \
    && javac --version \
    && native-image --version

USER root