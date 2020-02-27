# Alpine / MySQL Client 

> [MySQL client](https://dev.mysql.com/doc/refman/8.0/en/programs-client.html) tools on top of [Alpine Linux x86_64](https://hub.docker.com/_/alpine).

**Note:** [MySQL client (mariadb-client)](https://pkgs.alpinelinux.org/package/v3.11/main/x86_64/mysql-client) is an alias package for [mysql-client](https://dev.mysql.com/doc/refman/8.0/en/programs-client.html) migration tools.

## MySQL Client programs

```sh
mysql
mysql_find_rows
mysql_waitpid
mysqladmin
mysqldump
mysqlimport
mysql-export
mysql_fix_extensions
mysqlaccess
mysqlcheck
mysqldumpslow
mysqlshow
```

For more details check it out:

- [MariaDB 10 - Clients & Utilities](https://mariadb.com/kb/en/clients-utilities/)
- [MySQL 8 - Client Programs](https://dev.mysql.com/doc/refman/8.0/en/programs-client.html)

## User privileges

- Default user (unprivileged) is `mysql`.
- `mysql` home directory is located at `/home/mysql`.
- If you want a full privileged user try `root`. E.g append a `--user root` argument to `docker run`.

## Additional Tools

This image comes with some additional tools.

### Exporter

`mysql_exporter` is a custom tool which exports a database script using `mysqldump`. Additionally it support gzip compression.
It can be configured via environment variables or using `.env` file.

#### Setup via environment variables

```env
DB_PROTOCOL=TCP
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DEFAULT_CHARACTER_SET=utf8
DB_EXPORT_FILE_PATH=database.sql.gz
DB_EXPORT_GZIP=true
DB_NAME=db
DB_USERNAME=root
DB_PASSWORD="xyz"
DB_ARGS=
```

**Notes:**

- `DB_EXPORT_GZIP=true`: Compress the sql file using Gzip (optional). If `false` or not defined then the exported file will be a `.sql` file.
- `DB_ARGS`: can be used in order to pass more `mysqldump` arguments (optional). 
- An `.env` example file can be found at [./mysql_exporter.env](./mysql_exporter.env)

#### Exporting a database using a Docker container

The following Docker commands create a container in order to export a database and then remove such container automatically.

**Note:** `mysql_exporter` supports enviroment variables or a `.env` file passed as argument.

```sh
docker run --rm -it \
    --volume $(PWD):/home/mysql/sample \
    --workdir /home/mysql/sample \
        joseluisq/alpine-mysql-client:1 \
        mysql_exporter production.env

# Alpine / MySQL Client - Exporter
# ================================
# mysqldump  Ver 10.17 Distrib 10.4.12-MariaDB, for Linux (x86_64)
# Exporting database `mydb` to `mydb.sql.gz` file...
# Database `mydb` was exported successfully!
# 2.0M	mydb.sql.gz
```

__Notes:__

- `--volume $(PWD):/home/mysql/sample` specificy a [bind mount directory](https://docs.docker.com/storage/bind-mounts/) from host to container.
- `$(PWD)` is just my host working directory. Use your own path.
- `/home/mysql/` is default home directory user (optional). View [User privileges](#user-privileges) section above.
- `/home/mysql/sample` is a container directory that Docker will create for us.
- `--workdir /home/mysql/sample` specificy the working directory used by default inside the container.
- `production.env` is a custom env file path with the corresponding environment variables passed as argument. That file shoud available in your host working directory. E.g `$PWD` in my case.

#### Exporting a database using a Docker compose file

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

## Contributions

Feel free to send a [pull request](https://github.com/joseluisq/alpine-mysql-client/pulls) or file some [issue](https://github.com/joseluisq/alpine-mysql-client/issues).

## License

MIT license

© 2020 [Jose Quintana](https://git.io/joseluisq)
