#!/usr/bin/env bash

set -Eeo pipefail

if ! cut -d: -f3 /etc/passwd | grep -q ${OWNER_UID}; then
    addgroup -g "$OWNER_GID" owner
    adduser -h /home/owner -s /bin/bash -D -u "$OWNER_UID" -G owner owner
fi

if [ "$1" = 'unison' ]; then
    mkdir -p "$DATA_DIR"
    chown owner:owner "$DATA_DIR"

    mkdir -p /home/owner/.unison
    chown owner:owner /home/owner/.unison

    cp /etc/unison-default-profile.tpl /home/owner/.unison/default.prf

    IGNORED_DIR_LIST=(${IGNORED_DIRS//:/ })
    for ((i=0;i<${#IGNORED_DIR_LIST[@]};++i)); do
        echo "ignore = BelowPath ${IGNORED_DIR_LIST[$i]}" >> /home/owner/.unison/default.prf
    done

    cd "$DATA_DIR"
    exec su-exec owner tini -- "$@"
fi

exec "$@"
