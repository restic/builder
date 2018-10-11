This repository contains the build script and `Dockerfile` used to produce the
binaries for each restic release starting at 0.9.3.

Instructions
============

First, build the docker container:

    $ docker build -t restic/builder .

Then run the build as follows, mounting the directory with the source code as `/restic` and putting the resulting files in the directory `output`:

    $ mkdir output
    $ docker run --volume "$PWD/restic-0.9.3:/restic" --volume "$PWD/output:/output"

If all goes well then you've produced exactly the same binaries as in the official release.

The container has the official Go compiler installed in `/usr/local/go`.

Software
========

The Docker container is based on Debian stable and the official Go compiler is
used in the latest released version.
