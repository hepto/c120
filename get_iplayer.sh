#!/bin/bash

docker exec \
    c120 \
    get_iplayer --profile-dir /data/config --output /data/output \
    "$@"
