FROM --platform=$BUILDPLATFORM alpine:3.17.4 as build

ARG TARGETPLATFORM
ARG VERSION=0.0.0
ENV VERSION=${VERSION}
ARG ENVE_VERSION=1.4.1

RUN apk --no-cache add ca-certificates tzdata
RUN set -ex; \
    case "$TARGETPLATFORM" in \
        "linux/amd64") target='amd64' ;; \
        "linux/arm64") target='arm64' ;; \
        "linux/386") target='i386' ;; \
        "linux/arm/v7") target='armv7' ;; \
        "linux/arm/v6") target='armv6' ;; \
        *) echo >&2 "error: unsupported $TARGETPLATFORM architecture"; exit 1 ;; \
    esac; \
    wget --quiet -O /tmp/enve.tar.gz \
        "https://github.com/joseluisq/enve/releases/download/v${ENVE_VERSION}/enve_v${ENVE_VERSION}_linux_${target}.tar.gz"; \
    tar xzvf /tmp/enve.tar.gz -C /usr/local/bin enve; \
    enve -v; \
    chmod +x /usr/local/bin/enve; \
    true

FROM alpine:3.17.4

ARG VERSION=0.0.0
ENV VERSION=${VERSION}

LABEL version="${VERSION}" \
    description="MySQL client for easy export and import databases using Docker." \
    maintainer="Jose Quintana <joseluisq.net>"

# Dependencies
ENV BUILD_DEPS="gettext"
ENV RUNTIME_DEPS="libintl"

# Custom user
ARG USER_NAME
ARG USER_HOME_DIR

ENV USER_NAME=${USER_NAME:-mysql}
ENV USER_HOME_DIR=${USER_HOME_DIR:-/home/${USER_NAME}}

RUN set -eux \
    && adduser -h ${USER_HOME_DIR} -s /sbin/nologin -u 1000 -D ${USER_NAME} \
    && apk --no-cache add ca-certificates tzdata mysql-client nano dumb-init \
    && apk add --update $RUNTIME_DEPS \
    && apk add --virtual build_deps $BUILD_DEPS \
    && cp /usr/bin/envsubst /usr/local/bin/envsubst \
    && apk del build_deps \
    && true

COPY --from=build /usr/local/bin/enve /usr/local/bin/

COPY ./__mysqldump.sh /usr/local/bin/__mysqldump.sh
COPY ./mysql_exporter /usr/local/bin/mysql_exporter
COPY ./__mysqlimport.sh /usr/local/bin/__mysqlimport.sh
COPY ./mysql_importer /usr/local/bin/mysql_importer

RUN set -eux \
    && enve -v \
    && chmod +x /usr/local/bin/__mysqldump.sh \
    && chmod +x /usr/local/bin/__mysqlimport.sh \
    && chmod +x /usr/local/bin/mysql_exporter \
    && chmod +x /usr/local/bin/mysql_importer \
    && true

USER ${USER_NAME}

WORKDIR ${USER_HOME_DIR}

VOLUME ${USER_HOME_DIR}

ENTRYPOINT [ "/usr/bin/dumb-init" ]

CMD [ "mysql" ]

# Metadata
LABEL org.opencontainers.image.vendor="Jose Quintana" \
    org.opencontainers.image.url="https://github.com/joseluisq/alpine-mysql-client" \
    org.opencontainers.image.title="Alpine / MySQL Client" \
    org.opencontainers.image.description="MySQL client for easy export and import databases using Docker." \
    org.opencontainers.image.version="v${VERSION}" \
    org.opencontainers.image.documentation="https://github.com/joseluisq/alpine-mysql-client/blob/master/README.md"
