This repository contains the build script and `Dockerfile` used to produce the
binaries for each restic release starting at 0.6.1.

Instructions
============

First, build the docker container:

    $ docker build -t restic/build .

Then run the build as follows, passing the restic source code as a `.tar.gz` file:

    $ docker run --rm --volume $PWD:/home/build restic/build restic-0.6.1.tar.gz

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

Software
========

The Docker container is based on Debian stable and the official Go compiler is
used in the latest released version.
