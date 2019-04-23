#!/bin/bash

# enable strict mode
set -euo pipefail
IFS=$'\n\t'

latest="go1.12.4.linux-amd64.tar.gz"
hash="d7d1f1f88ddfe55840712dc1747f37a790cbcaa448f6c9cf51bbe10aa65442f5"

# download and install Go
cd /usr/local
wget --quiet "https://golang.org/dl/${latest}"
echo "${hash}  ${latest}" > hashes
sha256sum -c hashes

tar xf "${latest}"

rm -f hashes "${latest}"
