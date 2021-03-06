FROM alpine:$ALPINE_VERSION

LABEL maintainer="Jose Quintana <git.io/joseluisq>"

ARG USER_NAME
ARG USER_HOME_DIR

ENV BUILD_DEPS="gettext" \
    RUNTIME_DEPS="libintl" \
    \
    USER_NAME=${USER_NAME:-mysql} \
    USER_HOME_DIR=${USER_HOME_DIR:-/home/${USER_NAME}}

RUN adduser -h ${USER_HOME_DIR} -s /sbin/nologin -u 1000 -D ${USER_NAME} && \
    \
    apk --no-cache add ca-certificates tzdata mysql-client nano dumb-init && \
    \
    set -ex; \
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
    \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps && \
    wget --quiet -O /tmp/enve.tar.gz "https://github.com/joseluisq/enve/releases/download/v1.0.0/enve_v1.0.0_linux_$arch.tar.gz"; \
	tar xzvf /tmp/enve.tar.gz -C /usr/local/bin enve; \
	rm -f /tmp/enve.tar.gz; \
	chmod +x /usr/local/bin/enve

COPY ./__mysqldump.sh /usr/local/bin/__mysqldump.sh
COPY ./mysql_exporter /usr/local/bin/mysql_exporter
COPY ./__mysqlimport.sh /usr/local/bin/__mysqlimport.sh
COPY ./mysql_importer /usr/local/bin/mysql_importer

RUN chmod +x /usr/local/bin/__mysqldump.sh && \
    chmod +x /usr/local/bin/__mysqlimport.sh && \
    chmod +x /usr/local/bin/mysql_exporter && \
    chmod +x /usr/local/bin/mysql_importer

USER ${USER_NAME}
WORKDIR ${USER_HOME_DIR}
VOLUME ${USER_HOME_DIR}
EXPOSE 3306

ENTRYPOINT [ "/usr/bin/dumb-init" ]
CMD [ "mysql" ]

# Metadata
LABEL org.opencontainers.image.vendor="Jose Quintana" \
    org.opencontainers.image.url="https://github.com/joseluisq/alpine-mysql-client" \
    org.opencontainers.image.title="Alpine / MySQL Client" \
    org.opencontainers.image.description="MySQL client tools on top of Alpine Linux x86_64." \
    org.opencontainers.image.version="$VERSION" \
    org.opencontainers.image.documentation="https://github.com/joseluisq/alpine-mysql-client/blob/master/README.md"
