FROM alpine:latest

RUN apk --update --no-cache add \
  ffmpeg \
  perl-cgi \
  perl-mojolicious \
  perl-lwp-protocol-https \
  perl-xml-libxml \
  jq \
  su-exec 

RUN wget -qnd "https://bitbucket.org/shield007/atomicparsley/raw/68337c0c05ec4ba2ad47012303121aaede25e6df/downloads/build_linux_x86_64/AtomicParsley" && \
    install -m 755 -t /usr/local/bin ./AtomicParsley && \
    rm ./AtomicParsley

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

