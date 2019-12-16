#!/usr/bin/env bash
# Simply a wrapper for "vagrant cloud publish command".
# Uploads a virtualbox box package to vagrant cloud and releases it.
# Usage: <vc_box> [vc_box_ver]

BOX_PATH="output-ubuntu-1804-docker/package.box"
BOX_DESC="An Ubuntu box with Docker Engine - Community installed."

# check prerequsites - passed parameters and vagrant installation
if [ "$1" ]; then
    BOX=${1}
else
    echo "usage: ${0} <vc_box> [vc_box_version]"
    exit 1
fi

if [ "$2" ]; then
    BOX_VER=${2}
else
    BOX_VER=$(date +%y.%m.%d)
fi 

which vagrant > /dev/null || {
    echo "vagrant is not installed. Visit www.vagrantup.com and install it."
    exit 1
}

vagrant cloud publish \
    -s "${BOX_DESC}" \
    --description "${BOX_DESC}" \
    --force --release \
    ${BOX} ${BOX_VER} virtualbox ${BOX_PATH}