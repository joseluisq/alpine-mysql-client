# Alpine MySQL Client (MariaDB Client)

[![devel](https://github.com/joseluisq/alpine-mysql-client/actions/workflows/devel.yml/badge.svg)](https://github.com/joseluisq/alpine-mysql-client/actions/workflows/devel.yml) ![Docker Image Size](https://img.shields.io/docker/image-size/joseluisq/alpine-mysql-client/1) ![Docker Image Version](https://img.shields.io/docker/v/joseluisq/alpine-mysql-client/1) ![Docker Pulls](https://img.shields.io/docker/pulls/joseluisq/alpine-mysql-client.svg)

> [MySQL client](https://dev.mysql.com/doc/refman/8.0/en/programs-client.html) ([MariaDB Client](https://mariadb.com/kb/en/clients-utilities/)) for easy **export** and **import** databases using Docker.

_**Note:** If you are looking for a **MySQL 8 Client** then go to [Docker MySQL 8 Client](https://github.com/joseluisq/docker-mysql-client) project._

🐳  View on [Docker Hub](https://hub.docker.com/r/joseluisq/alpine-mysql-client/)

## MySQL Client programs

**Note:** [MySQL client (mariadb-client)](https://pkgs.alpinelinux.org/package/v3.21/main/x86_64/mysql-client) is an alias package for [mysql-client](https://dev.mysql.com/doc/refman/8.0/en/programs-client.html) migration tools.

```sh
# Equivalent MySQL client tools
mariadb
mariadb-access
mariadb-admin
mariadb-check
mariadb-dump
mariadb-dumpslow
mariadb-find-rows
mariadb-import
mariadb-secure-installation
mariadb-show
mariadb-waitpid
mysql_fix_extensions

# Tools provided by this image
mysql_exporter
mysql_importer
```

For more details check it out:

- [MariaDB 11 - Clients and Utilities](https://mariadb.com/kb/en/clients-utilities/)
- [MySQL 8 - Client Programs](https://dev.mysql.com/doc/refman/8.0/en/programs-client.html)

## Usage

```sh
docker run -it --rm joseluisq/alpine-mysql-client mariadb --version
# mariadb from 11.4.4-MariaDB, client 15.2 for Linux (x86_64) using readline 5.1
```

## User privileges

- Default user (unprivileged) is `mysql`.
- `mysql` home directory is located at `/home/mysql`.
- If you want a fully privileged user try `root`. E.g. append a `--user root` argument to `docker run`.

## Additional Tools

This image comes with some additional tools.

### Exporter

`mysql_exporter` is a custom tool that exports a database script using `mariadb-dump` (a.k.a. `mysqldump`). Additionally, it supports gzip compression.
It can be configured via environment variables or using `.env` file.

#### Setup via environment variables

```env
# Connection settings (optional)
DB_PROTOCOL=tcp
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DEFAULT_CHARACTER_SET=utf8

# GZip export file (optional)
DB_EXPORT_GZIP=false

# SQL or Gzip export file (optional).
# If `DB_IMPORT_GZIP` is `true` then file name should be `database_name.sql.gz`
DB_EXPORT_FILE_PATH=database_name.sql

# Database settings (required)
DB_NAME=""
DB_USERNAME=""
DB_PASSWORD=""

# Additional arguments (optional)
DB_ARGS=
```

**Notes:**

- `DB_EXPORT_GZIP=true`: Compress the SQL file using Gzip (optional). If `false` or not defined then the exported file will be a `.sql` file.
- `DB_ARGS`: can be used to pass more `mariadb-dump` (a.k.a. `mysqldump`) arguments (optional). 
- A `.env` example file can be found at [./mysql_exporter.env](./mysql_exporter.env)

#### Export a database using a Docker container

The following Docker commands create a container to export a database and then remove such container automatically.

**Note:** `mysql_exporter` supports environment variables or a `.env` file passed as an argument.

```sh
docker run --rm -it \
    --user $(id -u $USER):$(id -g $USER) \
    --volume $PWD:/home/mysql/sample \
    --workdir /home/mysql/sample \
        joseluisq/alpine-mysql-client:1 \
        mysql_exporter production.env

# Alpine / MySQL Client - Exporter
# ================================
# mariadb-dump from 11.4.4-MariaDB, client 10.19 for Linux (x86_64)
# Exporting database `mydb` into a SQL script file...
# Output file: mydb.sql.gz (SQL GZipped)
# Database `mydb` was exported on 0s successfully!
# File exported: mydb.sql.gz (10M / SQL GZipped)
```

__Notes:__

- `--volume $PWD:/home/mysql/sample` specificy a [bind mount directory](https://docs.docker.com/storage/bind-mounts/) from host to container.
- `$PWD` is just my host working directory. Use your own path.
- `/home/mysql/` is the default home directory user (optional). View [User privileges](#user-privileges) section above.
- `/home/mysql/sample` is a container directory that Docker will create for us.
- `--workdir /home/mysql/sample` specificies the working directory used by default inside the container.
- `production.env` is a custom env file path with the corresponding environment variables passed as argument. That file shoud available in your host working directory. E.g `$PWD` in my case.

#### Export a database using a Docker Compose file

```yaml
version: "3.3"

services:
  exporter:
    image: joseluisq/alpine-mysql-client:1
    env_file: .env
    command: mysql_exporter
    working_dir: /home/mysql/sample
    volumes:
      - ./:/home/mysql/sample
    networks:
      - default
```

### Importer

`mysql_importer` is a custom tool that imports a SQL script file (text or Gzip) using `mariadb` (a.k.a. `mysql`) command.
It can be configured via environment variables or using `.env` file.

#### Setup via environment variables

```env
# Connection settings (optional)
DB_PROTOCOL=tcp
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DEFAULT_CHARACTER_SET=utf8

# GZip import support (optional)
DB_IMPORT_GZIP=false

# SQL or Gzip import file (required)
# If `DB_IMPORT_GZIP` is `true` then file name should be `database_name.sql.gz`
DB_IMPORT_FILE_PATH=database_name.sql

# Database settings (required)
DB_NAME=""
DB_USERNAME=""
DB_PASSWORD=""

# Additional arguments (optional)
DB_ARGS=
```

#### Import a SQL script via a Docker container

The following Docker commands create a container to import an SQL script file to a specific database and remove the container afterward.

**Note:** `mysql_importer` supports environment variables or a `.env` file passed as an argument.

```sh
docker run --rm -it \
    --user $(id -u $USER):$(id -g $USER) \
    --volume $PWD:/home/mysql/sample \
    --workdir /home/mysql/sample \
        joseluisq/alpine-mysql-client:1 \
        mysql_importer production.env

# Alpine / MySQL Client - Importer
# ================================
# mariadb from 11.4.4-MariaDB, client 15.2 for Linux (x86_64) using readline 5.1
# Importing a SQL script file into database `dbtesting`...
# Input file: mydb.sql.gz (10M / SQL GZipped)
# Database `dbtesting` was imported on 1s successfully!
```

## Contributions

Feel free to send a [pull request](https://github.com/joseluisq/alpine-mysql-client/pulls) or file some [issues](https://github.com/joseluisq/alpine-mysql-client/issues).

## License

MIT license

© 2020-present [Jose Quintana](https://joseluisq.net)
