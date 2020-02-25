FROM alpine:3.11

LABEL maintainer="Jose Quintana <git.io/joseluisq>"

ENV BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"

RUN apk --no-cache add ca-certificates tzdata mysql-client nano
RUN set -ex; \
    apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
        armhf) arch='arm' ;; \
        aarch64) arch='arm64' ;; \
        x86_64) arch='amd64' ;; \
        *) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
    esac; \
    \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS && \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

COPY ./__mysqldump.sh /usr/local/bin/__mysqldump.sh
COPY ./mysql_exporter /usr/local/bin/mysql_exporter
RUN chmod +x /usr/local/bin/__mysqldump.sh && \
    chmod +x /usr/local/bin/mysql_exporter
