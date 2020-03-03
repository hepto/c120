#!/bin/sh

docker run -d \
    --name c120 \
    --restart unless-stopped \
    -e PUID=`id -u` \
    -e PGID=`id -g` \
    --mount source=c120-data,target=/c120/config \
    -v /path/to/downloads:/c120/downloads \
    hepto/c120
