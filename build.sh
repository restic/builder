#!/bin/bash

if [[ "$#" != 1 ]]; then
    echo "usage: build.sh restic-X-Y-Z.tar.gz" >&2
    exit 1
fi

release="$1"

set -e

tempdir=$(mktemp -d --tmpdir restic-release-XXXXXX)
echo "path is ${tempdir}"
outputdir=$(pwd)/build-$(date +%Y%m%d-%H%M%S)
mkdir "$outputdir"
echo "outputdir is $outputdir"

(cd "$tempdir"; tar xz --strip-components=1) < "$release"
cd "$tempdir"
version=$(cat VERSION)
echo "version is $version"

for R in       \
    darwin/386     \
    darwin/amd64   \
    freebsd/386    \
    freebsd/amd64  \
    freebsd/arm    \
    linux/386      \
    linux/amd64    \
    linux/arm      \
    linux/arm64    \
    openbsd/386   \
    openbsd/amd64 \
    windows/386    \
    windows/amd64  \
    ; do \

    os=$(dirname $R)
    arch=$(basename $R)
    filename=restic_${version}_${os}_${arch}

    if [[ "$os" == "windows" ]]; then
        filename="${filename}.exe"
    fi

    echo $filename

    go run build.go --goos $os --goarch $arch --output "${filename}"
    if [[ "$os" == "windows" ]]; then
        zip ${filename%.exe}.zip ${filename}
        rm ${filename}
        mv ${filename%.exe}.zip ${outputdir}
    else
        bzip2 ${filename}
        mv ${filename}.bz2 ${outputdir}
    fi
done

cd "$outputdir"
sha256sum restic_*.{zip,bz2} restic-$version.tar.gz > SHA256SUMS

echo "done"
