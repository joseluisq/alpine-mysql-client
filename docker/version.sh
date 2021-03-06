#!/bin/sh

set -e
set -u

LATEST_TAG=$1
BASE_PATH="$(pwd)/docker"

if [ $# -eq 0 ]; then
    echo "Usage: ./version.sh <tag or branch>"
    exit
fi

export VERSION=$LATEST_TAG
export ALPINE_VERSION=3.11

if [ ! -d "$BASE_PATH" ]; then
    echo "Directory no found for \"${BASE_PATH}\""
    exit 1
fi

echo "Generating Dockerfile for Alpine Linux v$ALPINE_VERSION x86_64"

rm -rf "${BASE_PATH}/Dockerfile"

envsubst \$ALPINE_VERSION,\$VERSION <"${BASE_PATH}/tmpl.Dockerfile" >"${BASE_PATH}/Dockerfile"

echo "Dockerfile $VERSION were created successfully!"
