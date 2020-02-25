# MySQL Tools

> MySQL client tools on Alpine image.

## MySQL Client Tools

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

## Setup

Setup is made using via `.env` files.

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

## Usage

### Exporter

`mysql_exporter` is a custom tool in order to export a database which supports `.env` files.

```sh
@docker run --rm -it \
    --name mysql-tools \
    --volume $(PWD):/root/sample \
    --workdir /root/sample \
    mysql-tools \
    mysql_exporter .env
```

__Note:__ `.env` is a custom file with the corresponding environment variables passed as argument.
