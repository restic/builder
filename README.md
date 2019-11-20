This repository contains the build script and `Dockerfile` used to produce the
binaries for each restic release starting at 0.9.3.

Instructions
============

**Note:** For more detailed instructions, reference the Reproducible Builds section of the [Developer Information](https://github.com/restic/restic/blob/master/doc/developer_information.rst).*

First, clone (or update) this repo:

    $ git clone https://github.com/restic/builder.git

    or

    $ git pull

Second, pull the base image and build the docker container:

    $ docker pull debian:stable
    $ docker build --no-cache -t restic/builder .

Maintainers may also publish the new image to Docker hub:

    $ docker push restic/builder

Next, download and extract the restic source code.

    $ curl -L https://github.com/restic/restic/archive/v0.9.3.tar.gz -O
    $ tar -xzvf v0.9.3.tar.gz

Then run the build as follows, mounting the directory with the source code as `/restic` and putting the resulting files in the directory `output`:

    $ mkdir output
    $ docker run --rm --volume "$PWD/restic-0.9.3:/restic" --volume "$PWD/output:/output" restic/builder

Verify Build
============
If all goes well then you've produced exactly the same binaries as in the official release.

To verify the linux amd64 build for example, run:

    $ sha256_restic=3c882962fc07f611a6147ada99c9909770d3e519210fd483cde9609c6bdd900c
    $ echo "${sha256_restic} output/restic_linux_amd64.bz2" | sha256sum -c -

Software
========

The Docker container is based on Debian stable and the official Go compiler is
used in the latest released version.

The container has the official Go compiler installed in `/usr/local/go`.
