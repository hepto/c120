FROM ubuntu as builder

WORKDIR /root

RUN apt-get update && apt-get install -y \
    git \
    make \
    golang

RUN git clone https://github.com/rjocoleman/get_iplayer_rss.git

WORKDIR get_iplayer_rss

RUN GOBIN=/root/go/bin go get && make

FROM ubuntu

RUN apt-get update && \
    apt-get install -y software-properties-common

RUN add-apt-repository ppa:jon-hedgerows/get-iplayer && \
    apt-get update && \
    apt-get install -y \
    get-iplayer \
    rsync \
    openssh-client

RUN mkdir -p /c120/downloads /c120/config

COPY --from=builder /root/get_iplayer_rss/get_iplayer_rss /usr/bin/
COPY c120.sh /usr/bin/

ENTRYPOINT ["c120.sh"]


