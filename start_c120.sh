#!/bin/bash

IPLAYER_DATA="/path/for/getiplayer/storage" # Path to store get_iplayer config and output
BASE_URL="https://my.podcast.host" # The URL to be written into the RSS file as the location of the files
RSYNC_USER="user" # The user on the host to login with
RSYNC_HOST="remotehost" # The hostname to connect to for sync of files
RSYNC_FOLDER="/path/to/webroot/" # The folder on the host to sync files to

docker run -d \
    --name c120 \
    --restart always \
    -v $IPLAYER_DATA:/data \
    -v $HOME/.ssh:/root/.ssh:ro \
    -e BASE_URL=$BASE_URL \
    -e RSYNC_USER=$RSYNC_USER \
    -e RSYNC_HOST=$RSYNC_HOST \
    -e RSYNC_FOLDER=$RSYNC_FOLDER \
    c120
