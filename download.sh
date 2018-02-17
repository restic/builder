#!/bin/bash

# enable strict mode
set -euo pipefail
IFS=$'\n\t'

latest="go1.10.linux-amd64.tar.gz"
hash="b5a64335f1490277b585832d1f6c7f8c6c11206cba5cd3f771dcb87b98ad1a33"

# download and install Go
cd /usr/local
wget --quiet "https://dl.google.com/go/${latest}"
echo "${hash}  ${latest}" > hashes
sha256sum -c hashes

tar xf "${latest}"

rm -f hashes "${latest}"
