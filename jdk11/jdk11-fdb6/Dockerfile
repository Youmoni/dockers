FROM adoptopenjdk/openjdk11:slim

#RUN apt-get update; apt-get install -y dnsutils
RUN apt-get update; apt-get install -y bash gawk sed grep bc coreutils dnsutils

COPY --from=youmoni/fdb6x /usr/lib/libfdb_c.so /usr/lib
COPY --from=youmoni/fdb6x /usr/bin/fdbcli /usr/bin/
#COPY --from=youmoni/foundationdb:6.0.18 /var/fdb/scripts/create_cluster_file.bash /app
