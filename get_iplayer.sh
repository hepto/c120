#!/bin/bash

docker exec \
    c120 \
    gosu user get_iplayer --profile-dir /c120/config --output /c120/downloads \
    "$@"
