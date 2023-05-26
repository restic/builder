# This Dockerfiles configures a container that is used to compile the released
# restic binaries.

FROM debian:stable

RUN true \
    # install packages
    && apt-get update && apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        git \
        gnupg \
        wget \
        zip \
    # cleanup package lists to save space
    && rm -rf /var/lib/apt/lists/*

# add go download script and gpg signature file
COPY download.sh /usr/local/bin/
COPY linux_signing_key.pub .

ARG GO_VERSION=1.20.3
# download and install go compiler
RUN chmod 755 /usr/local/bin/download.sh && /usr/local/bin/download.sh ${GO_VERSION}

ENV \
    # add go and local binaries to PATH
    PATH="/usr/local/go/bin:/usr/local/bin:${PATH}" \
    # set default timezone
    TZ=Europe/Berlin \
    # configure user home
    HOME=/home/build

RUN true \
    # add user
    && useradd -m -d $HOME -s /bin/bash build \
    # create directory to hold the source code
    && mkdir /restic && chown build /restic \
    # create directory to save the resulting files to
    && mkdir /output && chown build /output

# disable cgo
ENV CGO_ENABLED 0

# run everything below as user build
USER build
WORKDIR /restic

# by default, assume restic's source is in /restic, build for all architectures, and save the files to /output
CMD go run helpers/build-release-binaries/main.go

# usage:
# docker run --volume "$PWD/restic-0.10.0:/restic" --volume "$PWD/output:/output"
