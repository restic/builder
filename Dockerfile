# This Dockerfiles configures a container that is used to compile the released
# restic binaries.

FROM debian:stable

RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates wget bzip2 zip

ADD *.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh
ENV PATH="/usr/local/go/bin:/usr/local/bin:${PATH}"

RUN download.sh

# set default timezone
ENV TZ Europe/Berlin

# add and configure user
ENV HOME /home/build
RUN useradd -m -d $HOME -s /bin/bash build

# create directory to hold the source code
RUN mkdir /restic
RUN chown build /restic

# create directory to save the resulting files to
RUN mkdir /output
RUN chown build /output

# make sure the Go compiler does not use any network access
ENV GOPROXY off
# disable cgo
ENV CGO_ENABLED 0

# run everything below as user build
USER build
WORKDIR /restic

# by default, assume restic's source is in /restic, build for all architectures, and save the files to /output
CMD go run -mod=vendor helpers/build-release-binaries/main.go

# usage:
# docker run --volume "$PWD/restic-0.9.3:/restic" --volume "$PWD/output:/output"
