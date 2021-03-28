#!/bin/sh
VER=${1:-7.8.2}
git clone -b $VER --depth=1 https://github.com/ging/fiware-pep-proxy.git
cd fiware-pep-proxy/extras/docker/
docker build -t pep-proxy:$VER .
