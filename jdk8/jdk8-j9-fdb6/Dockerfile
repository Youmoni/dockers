# Fails with JVMSHRC155E Error copying username into cache name
# Directory permission gets reset on deploy
FROM adoptopenjdk/openjdk8-openj9:slim

COPY --from=youmoni/foundationdb:6.0.18 /usr/lib/libfdb_c.so /usr/lib
COPY --from=youmoni/foundationdb:6.0.18 /usr/bin/fdbcli /usr/bin/

RUN mkdir /opt/shareclasses

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"
ENV JAVA_TOOL_OPTIONS="-XX:+IgnoreUnrecognizedVMOptions -XX:+UseContainerSupport -XX:+IdleTuningCompactOnIdle -XX:+IdleTuningGcOnIdle"
ENV JAVA_OPTS="-Xmx128m -Xtune:virtualized -Xscmx128m -Xscmaxaot100m -Xshareclasses:cacheDir=/opt/shareclasses"
