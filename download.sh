#!/bin/bash

# enable strict mode
set -euo pipefail
IFS=$'\n\t'

latest="go1.11.1.linux-amd64.tar.gz"
hash="2871270d8ff0c8c69f161aaae42f9f28739855ff5c5204752a8d92a1c9f63993"

# download and install Go
cd /usr/local
wget --quiet "https://golang.org/dl/${latest}"
echo "${hash}  ${latest}" > hashes
sha256sum -c hashes

tar xf "${latest}"

rm -f hashes "${latest}"
