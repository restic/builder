#!/bin/bash

# enable strict mode
set -euo pipefail
IFS=$'\n\t'

latest="go1.11.4.linux-amd64.tar.gz"
hash="fb26c30e6a04ad937bbc657a1b5bba92f80096af1e8ee6da6430c045a8db3a5b"

# download and install Go
cd /usr/local
wget --quiet "https://golang.org/dl/${latest}"
echo "${hash}  ${latest}" > hashes
sha256sum -c hashes

tar xf "${latest}"

rm -f hashes "${latest}"
