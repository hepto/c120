#!/bin/sh

CONFIG=/c120/config
OUTPUT=/c120/downloads

while true
do 
    su-exec $PUID:$PGID /usr/local/bin/get_iplayer --profile-dir $CONFIG --output $OUTPUT --pvr
    echo "📻 c120.sh > Sleeping for 4 hours. 💤"
    sleep 14400
done

