#!/bin/sh
VER=${1:-7.9.2}
git clone -b $VER --depth=1 https://github.com/ging/fiware-idm.git
cd fiware-idm/extras/docker/
docker build --build-arg "DOWNLOAD=FIWARE_${VER}" -t idm:$VER .
