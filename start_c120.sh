#!/bin/bash

DOWNLOAD_PATH="/where/to/store/episodes" # Path on host to store get_iplayer config and output

# set a base URL to invoke the RSS generator
BASE_URL="https://my.podcast.host" # The URL to be written into the RSS file as the location of the files

# set some rsync details to rsync downloaded episodes somewhere else.
# note this relies on paswordless login, so the hosts ssh keys are mapped in.
RSYNC_USER="user" # The user on the host to login with
RSYNC_HOST="remotehost" # The hostname to connect to for sync of files
RSYNC_PATH="/path/to/webroot/" # The folder on the host to sync files to

docker run -d \
    --name c120 \
    --restart unless-stopped \
    -v $DOWNLOAD_PATH:/c120/downloads \
    --mount source=c120-data,target=/c120/config \
    -e BASE_URL=$BASE_URL \
    -v $HOME/.ssh:/root/.ssh:ro \
    -e RSYNC_USER=$RSYNC_USER \
    -e RSYNC_HOST=$RSYNC_HOST \
    -e RSYNC_FOLDER=$RSYNC_PATH \
    hepto/c120
