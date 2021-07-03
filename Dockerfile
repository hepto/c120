FROM alpine

RUN apk --update --no-cache add \
  ffmpeg \
  perl-cgi \
  perl-mojolicious \
  perl-lwp-protocol-https \
  perl-xml-libxml \
  jq \
  su-exec

RUN apk --update --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing add \
  atomicparsley

RUN wget -qO - "https://api.github.com/repos/get-iplayer/get_iplayer/releases/latest" > /tmp/latest.json && \
    echo get_iplayer release `jq -r .name /tmp/latest.json` && \
    wget -qO - "`jq -r .tarball_url /tmp/latest.json`" | tar -zxf - && \
    cd get-iplayer* && \
    install -m 755 -t /usr/bin ./get_iplayer && \
    cd / && \
    rm -rf get-iplayer* && \
    rm /tmp/latest.json

COPY c120.sh /usr/bin/

RUN mkdir -p /c120/config /c120/downloads
RUN chmod -R 777 /c120

CMD ["/usr/bin/c120.sh"]

