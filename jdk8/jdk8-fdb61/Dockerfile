FROM adoptopenjdk/openjdk8:slim

#RUN apt-get update; apt-get install -y dnsutils
RUN apt-get update; apt-get install -y bash gawk sed grep bc coreutils dnsutils

COPY --from=youmoni/fdb61 /usr/lib/libfdb_c.so /usr/lib
COPY --from=youmoni/fdb61 /usr/bin/fdbcli /usr/bin/
#COPY --from=youmoni/fdb61 /var/fdb/scripts/create_cluster_file.bash /app
