#!/bin/bash

: '
    This script downloads and extracts the lastest version of Go available
    for the architecture where this script is executed. It supports all the
    main archictures.

    How does it work?

    1. Downloads the raw content from the Go download page.
    2. Collects all the available versions which are in development or rc.
    3. Sorts by the number of the release and get the latest one.
    4. Downloads it, extracts and put the content at /usr/local
'

# Enable strict mode
set -euo pipefail
IFS=$'\n\t'

# Downloads the raw content from Go download page
function get_content { 
    local content
    content=$(wget https://golang.org/dl/ -q -O -)
    # Returns the raw content
    echo "$content"
}

# Filter the raw data collected from Go download page and
# returns an array with all supported versions for a
# given a supported architecture
function get_all_versions () {
    if [ $# -eq 0 ]
    then
        echo "No architecture set."
        return
    fi

    local content
    content=$(get_content $ARCH)

    # From the raw content, gets all URLs that contains the desired
    # architecture, is Linux, is a tar file and is NOT a beta or rc. 
    # Then remove the prefix and the suffix to get only the version 
    # number.
    versions=( "$(echo "$content" | grep -Eoi '<a [^>]+>' | \
    grep -Eo 'href="[^\"]+"' | grep "$1" | grep linux | grep "tar.gz" | \
    awk '!/beta/' | awk '!/rc/' | sed -e "s/^href=//" | tr -d '",' | \
    awk '{split($0, array, "/"); print array[5]}' | \
    sort -t. -k 1,1n -k 2,2n -k 3,3n | uniq | sed -e "s/^go//" | \
    sed -e "s/.linux-$1.tar.gz//")" )

    # Returns an array with all supported versions
    echo "${versions[@]}"
}

# Returns the lastest version of Go available for a given
# architecture
function download_go () { 
    if [ $# -eq 0 ]
    then
        echo "The GO version or the architecture is missing."
        return
    fi
    wget https://dl.google.com/go/go"$1".linux-"$2".tar.gz
    tar -C /usr/local -xzf go"$1".linux-"$2".tar.gz
}

function run (){

    # Get the correct architecture
    ARCH=$(uname -m)
    # Replace x86_64 for amd64 because this is how Go named it :)
    if [ "$ARCH" = "x86_64" ]
    then
        ARCH="amd64"
    fi

    # Get all available versions of Go
    all=( $(get_all_versions $ARCH) )

    # Based on all collected versions, grab the latest available
    lastest_version=${all[${#all[@]}-1]}

    # Download the lastest version
    download_go "$lastest_version" $ARCH
}

### Main Execution ###
run "$@"