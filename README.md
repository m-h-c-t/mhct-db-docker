# 🐳 MHCT DB Docker &middot; [![Build Status](https://img.shields.io/docker/cloud/build/tsitu/mhct-db-docker.svg)](https://hub.docker.com/r/tsitu/mhct-db-docker/builds)

Docker images aimed at simplifying access to MHCT's various databases. Each image contains a MySQL 8.0 (debian) server preloaded with data from [MHCT's backups](https://backups.mhct.win/).

Based on [Bavo's repo](https://github.com/bavovanachte/jacks-tools-docker).

## Images / Tags
```bash
- tsitu/mhct-db-docker:latest       # NIGHTLY 'mhhunthelper' dump
- tsitu/mhct-db-docker:weekly       # WEEKLY  'mhhunthelper' dump
- tsitu/mhct-db-docker:converter    # WEEKLY  'mhconverter'  dump
- tsitu/mhct-db-docker:mapspotter   # WEEKLY  'mhmapspotter' dump
```

## Installation

```bash
$ docker pull tsitu/mhct-db-docker:$DESIRED_TAG
$ docker run -p 3306:3306 -d tsitu/mhct-db-docker:$DESIRED_TAG
```

This should set up a server that you can query on `localhost:3306`.

*Note:* Replace `localhost` with `docker-machine ip` if you are using Docker Toolbox (most common IP is `192.168.99.100`)

## Running Multiple Databases At Once

If you want to start all (or most) of the databases and connect to them from an external tool you can use something like:

```
$ docker run -p 3306:3306 -d --name mhct-mhhunthelper tsitu/mhct-db-docker:latest
$ docker run -p 3307:3306 -d --name mhct-converter tsitu/mhct-db-docker:converter
$ docker run -p 3309:3306 -d --name mhct-mapspotter tsitu/mhct-db-docker:mapspotter
```

MySQL's default port is 3306. You will need to use the first number after the `-p` (3306, 3307, 3308, or 3309) to connect to the database you want.

## Credentials

```bash
ENV MYSQL_ROOT_PASSWORD=secret
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=admin

ENV MYSQL_DATABASE=mhhunthelper  # for 'latest' and 'weekly' image tags
# OR
ENV MYSQL_DATABASE=mhconverter   # for 'converter' image tag
# OR
ENV MYSQL_DATABASE=mhmapspotter  # for 'mapspotter' image tag
```
