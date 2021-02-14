#!/bin/bash

# enable strict mode
set -euo pipefail
IFS=$'\n\t'

latest="1.15.8"
file="go${latest}.linux-amd64.tar.gz"

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
