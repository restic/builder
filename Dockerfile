# This Dockerfiles configures a container that is used to compile the released
# restic binaries.

FROM golang

RUN apt-get update
RUN apt-get install -y --no-install-recommends bzip2 zip

# add and configure user
ENV HOME /home/build
RUN useradd -m -d $HOME -s /bin/bash build

ADD build.sh /usr/local/bin/build.sh
RUN chmod 755 /usr/local/bin/build.sh

# run everything below as user build
USER build
WORKDIR $HOME

ENTRYPOINT ["/usr/local/bin/build.sh"]
