First, build the docker container:

    docker build -t restic/build .

Then run the build as follows, passing the restic source code as a `.tar.gz` file:

    docker run --volume $PWD:/home/build restic/build ./build.sh restic-0.6.0.tar.gz
