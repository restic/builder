# This Dockerfiles configures a container that is used to compile the released
# restic binaries.

FROM debian

RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates wget bzip2 zip

ADD *.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh
ENV PATH="/usr/local/go/bin:/usr/local/bin:${PATH}"

RUN download.sh

# add and configure user
ENV HOME /home/build
RUN useradd -m -d $HOME -s /bin/bash build

# run everything below as user build
USER build
WORKDIR $HOME
