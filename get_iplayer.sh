#!/bin/sh

CONFIG=/c120/config
OUTPUT=/c120/downloads

docker exec \
    c120 \
    su-exec `id -u`:`id -g` get_iplayer --profile-dir $CONFIG --output $OUTPUT \
    "$@"
