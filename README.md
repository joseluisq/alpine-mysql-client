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

**Note:** For more details take a look at:

- [MariaDB 10 - Clients & Utilities](https://mariadb.com/kb/en/clients-utilities/)
- [MySQL 8 - Client Programs](https://dev.mysql.com/doc/refman/8.0/en/programs-client.html)

## Additional Tools

This image comes with some additional tools:

### Exporter

`mysql_exporter` is a custom tool which exports a database script using `mysqldump`. Additionally it support gzip compression.
It can be configured via a `.env` file.

#### Setup via environment variables

Setup can be done using a `.env` file.

```env
DB_PROTOCOL=TCP
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DEFAULT_CHARACTER_SET=utf8
DB_EXPORT_FILE_PATH=database.sql.gz
DB_EXPORT_GZIP=true
DB_NAME=db
DB_USERNAME=root
DB_PASSWORD=""
DB_ARGS=
```

**Notes: **

- `DB_EXPORT_GZIP=true`: Compress the sql file using Gzip (optional)

#### Export database using a Docker container

```sh
docker run --rm -it \
    --name joseluisq/alpine-mysql-client \
    --volume $(PWD):/root/sample \
    --workdir /root/sample \
    joseluisq/alpine-mysql-client \
    mysql_exporter .env
```

__Note:__ `.env` is a custom file with the corresponding environment variables passed as argument.
