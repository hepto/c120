#!/bin/bash

docker run -d \
    --name c120 \
    --restart always \
    -v /media/downloads/c120:/data \
    c120
