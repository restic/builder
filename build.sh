#!/bin/bash

go version

# enable strict mode
set -euo pipefail
IFS=$'\n\t'

if [[ "$#" != 1 ]]; then
    echo "usage: build.sh restic-X-Y-Z.tar.gz" >&2
    exit 1
fi

export GOCACHE="/tmp/.cache"

release="$1"

set -e

startdir="$PWD"
tempdir=$(mktemp -d --tmpdir restic-release-XXXXXX)
echo "path is ${tempdir}"

(cd "$tempdir"; tar xz --strip-components=1) < "$release"
cd "$tempdir"
version=$(cat VERSION)
echo "version is $version"

outputdir="$startdir/restic-$version-$(date +%Y%m%d-%H%M%S)"
mkdir "$outputdir"
echo "outputdir is $outputdir"

cp "$startdir/$release" "$outputdir"

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
    solaris/amd64 \
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
        # set the same timestamp as the version file for the resulting exe, so
        # that we get reproducible builds (unfortunately ZIP files contain
        # several timestamp that would otherwise be different ever time restic
        # is compiled).
        touch --reference VERSION ${filename}

        zip -X ${filename%.exe}.zip ${filename}
        rm ${filename}
        mv ${filename%.exe}.zip ${outputdir}
    else
        bzip2 ${filename}
        mv ${filename}.bz2 ${outputdir}
    fi
done

cd "$outputdir"
sha256sum restic_*.{zip,bz2} "$release" > SHA256SUMS

echo "done"
