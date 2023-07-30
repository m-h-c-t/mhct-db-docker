FROM mysql:8.0-debian AS builder

# That file does the DB initialization but also runs mysql daemon, by removing the last line it will only init
RUN ["sed", "-i", "s/exec \"$@\"/echo \"not running $@\"/", "/usr/local/bin/docker-entrypoint.sh"]

# needed for intialization
ENV MYSQL_ROOT_PASSWORD=secret
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=admin
ENV MYSQL_DATABASE=mhhunthelper

# Setup
RUN apt-get update && apt-get install -y curl
RUN echo "[ DB Last Updated ]" && curl -s https://backups.mhct.win/nightly/last_updated.txt
RUN curl -s https://backups.mhct.win/nightly/hunthelper_nightly.sql.gz -o /docker-entrypoint-initdb.d/hunthelper_nightly.sql.gz

# Add configuration file
COPY ./init.cnf /etc/mysql/conf.d/

# Need to change the datadir to something else that /var/lib/mysql because the parent docker file defines it as a volume.
# https://docs.docker.com/engine/reference/builder/#volume :
#       Changing the volume from within the Dockerfile: If any build steps change the data within the volume after
#       it has been declared, those changes will be discarded.
RUN ["/usr/local/bin/docker-entrypoint.sh", "mysqld", "--datadir", "/initialized-db", "--skip-log-bin", "--innodb-flush-log-at-trx-commit=0", "--innodb-fast-shutdown=0", "--innodb-doublewrite=0"]

FROM mysql:8.0-debian

# Copy the pre-initialized database and runtime config
COPY ./config-file.cnf /etc/mysql/conf.d/
COPY --from=builder /initialized-db /var/lib/mysql

# MySQL daemon configuration
EXPOSE 3306
CMD ["mysqld"]
