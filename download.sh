#!/bin/bash

# enable strict mode
set -euo pipefail
IFS=$'\n\t'

latest="go1.10.3.linux-amd64.tar.gz"
hash="fa1b0e45d3b647c252f51f5e1204aba049cde4af177ef9f2181f43004f901035"

# download and install Go
cd /usr/local
wget --quiet "https://dl.google.com/go/${latest}"
echo "${hash}  ${latest}" > hashes
sha256sum -c hashes

tar xf "${latest}"

rm -f hashes "${latest}"
