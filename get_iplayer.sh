#!/bin/bash

docker exec \
    c120 \
    su-exec `id -u`:`id -g` /usr/bin/get_iplayer --profile-dir /c120/config --output /c120/downloads \
    "$@"
