FROM mysql:8.0.31-debian as builder

# That file does the DB initialization but also runs mysql daemon, by removing the last line it will only init
RUN ["sed", "-i", "s/exec \"$@\"/echo \"not running $@\"/", "/usr/local/bin/docker-entrypoint.sh"]

# needed for intialization
ENV MYSQL_ROOT_PASSWORD=secret
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=admin
ENV MYSQL_DATABASE=mhhunthelper

# Setup
RUN apt-get update && apt-get install -y curl
ADD ./_preload.sh /docker-entrypoint-initdb.d/

# COPY db files to /docker-entrypoint-initdb.d/
RUN echo "[ DB Last Updated ]" && curl https://devjacksmith.keybase.pub/mh_backups/nightly/last_updated.txt?dl=1
RUN curl https://devjacksmith.keybase.pub/mh_backups/nightly/hunthelper_nightly.sql.gz?dl=1 -o /docker-entrypoint-initdb.d/hunthelper_nightly.sql.gz

# Need to change the datadir to something else that /var/lib/mysql because the parent docker file defines it as a volume.
# https://docs.docker.com/engine/reference/builder/#volume :
#       Changing the volume from within the Dockerfile: If any build steps change the data within the volume after
#       it has been declared, those changes will be discarded.
RUN ["/usr/local/bin/docker-entrypoint.sh", "mysqld", "--datadir", "/initialized-db"]

FROM mysql:8.0.31-debian

COPY --from=builder /initialized-db /var/lib/mysql
