#!/bin/bash

while true
do 
    /usr/bin/get_iplayer --profile-dir /data/config --output /data/output --pvr
    /usr/bin/get_iplayer_rss gen -d /data/config -o /data/output -u $BASE_URL
    rsync -avzh /data/output/ $RSYNC_USER@$RSYNC_HOST:$RSYNC_FOLDER
    sleep 14400
done

