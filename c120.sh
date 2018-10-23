#!/bin/bash 

# We are running get_iplayer in Docker which sends a SIGTERM when a container is stopped.
# Unforutnatley, the pvr_lock is not removed on a SIGTERM so fails to start up again.
# This is then fatal on a reboot as the scheduler will not start again.
# Fix is to catch the SIGTERM and convert it into a SIGINT which will remove the lock.

_term() { 
  echo "Caught SIGTERM signal!" 
  kill -2 "$child" 2>/dev/null
}

trap _term SIGTERM

/usr/bin/get_iplayer --profile-dir /data/config --output /data/output --pvrscheduler 3600 &

child=$! 
wait "$child"
