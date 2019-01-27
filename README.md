# c120

c120 is a system to grab BBC Radio programs and publish to RSS for subscription in a plain old podcast app.

## what?

c120 has two main components:

* a long running script (`c120`) that periodically downloads subscribed shows from the BBC, creates an RSS feed for them and then syncs them to a static webhost so that the feed can be added to a podcast app
* a wrapper to the popular `get_iplayer` script to search and schedule recordings inside `c120`.

It all lives within a Docker container so you don't have to worry about dependencies or configuration - just run and go!

Basically you start the Docker image and use the wrapper script to schedule a "recordings".  Every 4 hours `c120` will check for new episodes, download and tag them, create an RSS feed and then rsync them to another location, typically for hosting.

## how?

```
docker run -d \
    --name c120 \
    --restart unless-stopped \
    -v $DOWNLOAD_PATH:/c120/dowloads \
    --mount source=c120-data,target=/c120/config \
    -e BASE_URL=$BASE_URL \
    -v $HOME/.ssh:/root/.ssh:ro \
    -e RSYNC_USER=$RSYNC_USER \
    -e RSYNC_HOST=$RSYNC_HOST \
    -e RSYNC_PATH=$RSYNC_PATH \
    hepto/c120
```

Where:

`DOWNLOAD_PATH` is where you want episodes to be downloaded to (on the host).

`BASE_URL` is the base URL for the RSS feed (i.e. where the episodes will be available from across the tubes).

`RSYNC_*` are credentials to sync the downloaded episodes (and RSS file) somewhere else - e.g. a web host or for backup purposes.

Note, if BASE_URL or any of the RSYNC_* are not provided, the episodes will still be downloaded but the RSS generation and rsync will not be performed.  (Effectively this then just becomes a Docker wrapper to the basic `get_iplayer` PVR.)

For ease, the `start_c120.sh` script can be edited with your personal details - it's simply a wrapper to `docker run`, but there are some variables in there you need to customise to yourself.  Once thats all sorted:

```
./start_c120.sh
```

Now you should have running containeer called `c120`.

If you use the instructions above, then all get_iplayer config is stored in a Docker volume called `c120-data` so that the container can be reloaded and all scheudled recordings are not lost.  You can put this somewhere else by mapping `c120/config` somehere else.

Next is to schedule some recordings.  The `get_iplayer.sh` script simply wraps the standard `get_iplayer` script, but sets the right download locations inside the image.  So check the docs for `get-iplayer` to see what you can do in full, but typically you're gonna do:

```
./get_iplayer.sh --type="radio" "search_term"
```

This will search the available programs, and give you an ID.

Then to get a single program, one time:

```
./get_iplayer.sh --get ID
```

This will get that episode and put it in the right location so that next time `c120` runs it will create an RSS feed for it.

BUT, you are more likely to want to schedule a series!  `get_iplayer` is clever enough to work out a series from a single episode, so simply call:

```
./get_iplayer.sh --pvr-series ID
```

And it will be added to the list.  Next time `c120` runs it will then download all episdoe for that program, and create the RSS feed.

All the audio and RSS files will then be synced to your host of choice - and there'll be one RSS feed per program.

NOTE - the script relies on using public key authentication to the remote rsync path to avoid having passwords in any of the config, or being prompted, so the local .ssh directory of the host is mapped into the Docker image so it has access to the keys.

Configuring hosting and all that is an excercise for the reader, but an easy way is to enable directory listing on the web server so you can then copy the paths to the RSS feeds and add them to your reader. Oh and think about using basic auth and letsencrypt while you're there ...

Note, it's perfectly reasonbable to mount the output location as the webroot in another Docker image and serve from it directly.  I do this and use the rsync simply as a backup!

## why?

In a nutshell, I kept forgetting to listen to shows before they dissapeared!  So I wanted a way to be notified/reminded that a show was available, and I coudln't find a way for the BBC to do that themselves.

Also, while the BBC does a great job of publishing content through its iPlayer app and various podcasts, unfortuantely live shows aren't generally available outside of the BBC app, and you can only listen again up to 30 days later.

## why c120?

It's a thowback to the days of cassettes where c120 was a type of cassette, 120 mins in length.  This just happens to be the same length as the BBC Essential Mixes, so I had plenty of these when I was young to record the shows!  This app is just the modern equivalent ...
