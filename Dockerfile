# This Dockerfiles configures a container that is used to compile the released
# restic binaries.

FROM debian:jessie

ARG GOVERSION=1.8.3
ARG GOARCH=amd64

# install dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates wget zip bzip2

# download and install Go
RUN wget -q -O /tmp/go.tar.gz https://storage.googleapis.com/golang/go${GOVERSION}.linux-${GOARCH}.tar.gz
RUN cd /usr/local && tar xf /tmp/go.tar.gz && rm -f /tmp/go.tar.gz
ENV PATH $PATH:/usr/local/go/bin

# add and configure user
ENV HOME /home/build
RUN useradd -m -d $HOME -s /bin/bash build

# run everything below as user build
USER build
WORKDIR $HOME

ADD build.sh /usr/local/bin/build.sh
ENTRYPOINT ["/usr/local/bin/build.sh"]
