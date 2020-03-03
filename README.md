# c120-minimal

c1200-minimal tries to be a very minimal image of get_iplayer to download readio programs.

## what?

c120 has two main components:

* a long running script (`c120`) that periodically downloads subscribed shows from the BBC.
* a wrapper to the popular `get_iplayer` script to search and schedule recordings inside `c120`.

It all lives within a Docker container so you don't have to worry about dependencies or configuration - just run and go!

Basically you start the Docker image and use the wrapper script to schedule a "recording".  Every 4 hours `c120` will check for new episodes and download to a shared drive.

## how?

```
#!/bin/sh

docker run -d \
    --name c120 \
    --restart unless-stopped \
    -e PUID=`id -u` \
    -e PGID=`id -g` \
    --mount source=c120-data,target=/c120/config \
    -v /path/to/downloads:/c120/downloads \
    hepto/c120

```

For ease, the `start_c120.sh` script can be edited with your personal details - it's simply a wrapper to `docker run` above.

```
./start_c120.sh
```

Now you should have running container called `c120`.

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

## why?

In a nutshell, I kept forgetting to listen to shows before they dissapeared!  So I wanted a way to be notified/reminded that a show was available, and I coudln't find a way for the BBC to do that themselves.

Also, while the BBC does a great job of publishing content through its iPlayer app and various podcasts, unfortuantely live shows aren't generally available outside of the BBC app, and you can only listen again up to 30 days later.

## why c120?

It's a thowback to the days of cassettes where c120 was a type of cassette, 120 mins in length.  This just happens to be the same length as the BBC Essential Mixes, so I had plenty of these when I was young to record the shows!  This app is just the modern equivalent ...
