#!/bin/bash

# enable strict mode
set -euo pipefail
IFS=$'\n\t'

latest="go1.10.2.linux-amd64.tar.gz"
hash="4b677d698c65370afa33757b6954ade60347aaca310ea92a63ed717d7cb0c2ff"

# download and install Go
cd /usr/local
wget --quiet "https://dl.google.com/go/${latest}"
echo "${hash}  ${latest}" > hashes
sha256sum -c hashes

tar xf "${latest}"

rm -f hashes "${latest}"
