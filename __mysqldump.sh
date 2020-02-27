#!/bin/sh

set -e

XDB_PROTO="$DB_PROTOCOL"
XDB_HOST="$DB_HOST"
XDB_PORT="$DB_PORT"
XDB_DEFAULT_CHARACTER_SET="$DB_DEFAULT_CHARACTER_SET"
XDB_EXPORT_FILE="$DB_EXPORT_FILE_PATH"
XDB_EXPORT_GZIP="$DB_EXPORT_GZIP"
XDB_EXPORT=

if [ -z "$XDB_PROTO" ]; then XDB_PROTO="tcp"; fi
if [ -z "$XDB_HOST" ]; then XDB_HOST="127.0.0.1"; fi
if [ -z "$XDB_PORT" ]; then XDB_PORT="3306"; fi
if [ -z "$XDB_DEFAULT_CHARACTER_SET" ]; then XDB_DEFAULT_CHARACTER_SET=utf8; fi
if [ -z "$XDB_EXPORT_FILE" ]; then XDB_EXPORT_FILE="./$DB_NAME.sql"; fi
if [ -n "$XDB_EXPORT_GZIP" ] && [ "$XDB_EXPORT_GZIP" = "true" ]; then
    XDB_EXPORT_FILE="$XDB_EXPORT_FILE.gz"
    XDB_EXPORT="| gzip -c > $XDB_EXPORT_FILE"
else
    XDB_EXPORT="> $XDB_EXPORT_FILE"
fi

MYEXPORT="\
--protocol=$XDB_PROTO \
--host=$XDB_HOST \
--port=$XDB_PORT \
--default-character-set=$XDB_DEFAULT_CHARACTER_SET \
--user=$DB_USERNAME \
--password=\"$DB_PASSWORD\" \
$DB_ARGS $DB_NAME $XDB_EXPORT"

echo "Alpine / MySQL Client - Exporter"
echo "================================"

mysqldump --version

echo "Exporting database \`$DB_NAME\` to \`$XDB_EXPORT_FILE\` file..."

eval mysqldump $MYEXPORT

echo "Database \`$DB_NAME\` was exported successfully!"
du -sh $XDB_EXPORT_FILE
