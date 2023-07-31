#!/bin/bash

# enable strict mode
set -euo pipefail
IFS=$'\n\t'

if [[ $# -ne 1 ]]; then
    echo >&2 "Usage: download.sh GO_VERSION"
    exit 1
fi

latest="$1"
file="go${latest}.linux-arm64.tar.gz"

# import GPG key, can be downloaded here:
# https://dl.google.com/dl/linux/linux_signing_key.pub
# more info:
# https://github.com/golang/go/issues/14739#issuecomment-324528605
gpg --import linux_signing_key.pub

# download and install Go
cd /usr/local
wget --quiet "https://dl.google.com/go/${file}"
wget --quiet "https://dl.google.com/go/${file}.asc"
gpg --verify "${file}.asc" "${file}"

tar xf "${file}"
rm "${file}"
