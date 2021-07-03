FROM alpine

RUN apk add --update --no-cache \
  ffmpeg \
  perl-cgi \
  perl-mojolicious \
  perl-lwp-protocol-https \
  perl-xml-libxml \
  jq \
  su-exec

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  atomicparsley

# get_iplayer expects the atomicparsley binary to be capitalised.
RUN ln -s `which atomicparsley` /usr/local/bin/AtomicParsley

RUN wget -qO - "https://api.github.com/repos/get-iplayer/get_iplayer/releases/latest" > /tmp/latest.json && \
    echo get_iplayer release `jq -r .name /tmp/latest.json` && \
    wget -qO - "`jq -r .tarball_url /tmp/latest.json`" | tar -zxf - && \
    cd get-iplayer* && \
    install -m 755 -t /usr/local/bin ./get_iplayer && \
    cd / && \
    rm -rf get-iplayer* && \
    rm /tmp/latest.json

COPY c120.sh /usr/local/bin/

RUN mkdir -p /c120/config /c120/downloads
RUN chmod -R 777 /c120

CMD ["/usr/local/bin/c120.sh"]

