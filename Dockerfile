FROM debian as builder

WORKDIR /root

RUN apt-get update && apt-get install -y \
  git \
  make \
  golang

RUN git clone https://github.com/rjocoleman/get_iplayer_rss.git

WORKDIR get_iplayer_rss

RUN GOBIN=/root/go/bin go get && make

FROM debian

RUN apt-get update && apt-get install -y \
  wget \
  rsync \
  openssh-client \
  gosu

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

RUN apt-get update && apt-get install -y \
  build-essential \
  libwww-perl \
  liblwp-protocol-https-perl \
  libmojolicious-perl \
  libxml-libxml-perl \
  libcgi-pm-perl \
  cpanminus \
  liblocal-lib-perl \
  atomicparsley \
  ffmpeg

RUN wget https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer
RUN install -m 755 ./get_iplayer /usr/local/bin

RUN mkdir -p /c120/downloads /c120/config
RUN chmod -R 777 /c120

COPY --from=builder /root/get_iplayer_rss/get_iplayer_rss /usr/local/bin/
COPY c120.sh /usr/bin/

CMD ["c120.sh"]

