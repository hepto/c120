#!/bin/bash

# common folders, expected to be mapped by `docker run` to a location on the host
CONFIG=/c120/config
OUTPUT=/c120/downloads

while true
do 
    # run PVR to download new episodes
    /usr/bin/get_iplayer --profile-dir $CONFIG --output $OUTPUT --pvr

    # if BASE_URL set then create an RSS feed from all downloaded episodes
    if [[ -z $BASE_URL ]]; then
    	echo "c120.sh > No RSS base URL found, so not creating RSS feed"
    else
    	echo "c120.sh > Creating RSS feed"
    	/usr/bin/get_iplayer_rss gen -d $CONFIG -o $OUTPUT -u $BASE_URL
    fi
    
    # if RSYNC_* set then sync downladed episodes to provided host
    if [[ -z $RSYNC_USER || -z $RSYNC_HOST || -z $RSYNC_PATH ]]; then
    	echo "c120.sh > Complete rsync credentials not found, so not attempting rysnc"
    else
    	echo "c120.sh > Attempting rsync"
    	rsync -avzh /data/output/ $RSYNC_USER@$RSYNC_HOST:$RSYNC_PATH
	fi

	# sleep for 4 hours
	echo "c120.sh > Sleeping for 4 hours. zzz"
    sleep 14400
done

