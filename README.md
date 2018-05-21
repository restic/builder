This repository contains the build script and `Dockerfile` used to produce the
binaries for each restic release starting at 0.6.1.

Instructions
============

First, build the docker container:

    $ docker build -t restic/builder .

Then run the build as follows, passing the restic source code as a `.tar.gz` file:

    $ docker run --rm --volume $PWD:/home/build restic/builder build.sh restic-0.6.1.tar.gz

The binaries will be created in a sub-directory of the current directory, like this:

    $ ls -al restic-0.6.1-20170531-202748
    restic_0.6.1_darwin_386.bz2
    restic_0.6.1_darwin_amd64.bz2
    restic_0.6.1_freebsd_386.bz2
    restic_0.6.1_freebsd_amd64.bz2
    restic_0.6.1_freebsd_arm.bz2
    restic_0.6.1_linux_386.bz2
    restic_0.6.1_linux_amd64.bz2
    restic_0.6.1_linux_arm64.bz2
    restic_0.6.1_linux_arm.bz2
    restic_0.6.1_openbsd_386.bz2
    restic_0.6.1_openbsd_amd64.bz2
    restic-0.6.1.tar.gz
    restic_0.6.1_windows_386.zip
    restic_0.6.1_windows_amd64.zip
    SHA256SUMS

If all goes well then you've produced exactly the same binaries as in the official release.

The container has the official Go compiler installed in `/usr/local/go`. After
extracting the `tar.gz` into a temporary directory, the script `build.sh`
builds the binaries by running `build.go` like this:

    $ go run build.go --goos $os --goarch $arch --tempdir /tmp/gopath --output restic_$os_$arch

Verifying Windows Binaries
--------------------------

The Windows binaries are packed as a ZIP file, which unfortunately includes a
time stamp, so you'll end up with different ZIP files than the original
release. So in order to verify that the released binaries are indeed authentic,
download the ZIP files, verify the authenticity (via `sha256sums` and `gpg`)
then extract the EXE file. Rebuild the binaries using this docker container,
extract the EXE file from the ZIP and you'll end up with two byte identical
files.

Software
========

The Docker container is based on Debian stable and the official Go compiler is
used in the latest released version.
