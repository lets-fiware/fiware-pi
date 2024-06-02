#!/bin/sh
VER=${1:-2.11.0}
if [ -e "fiware-sth-comet" ]; then
  rm -fr fiware-sth-comet
fi
git clone -b $VER --depth=1 https://github.com/telefonicaid/fiware-sth-comet.git
cd fiware-sth-comet/docker
docker build -t letsfiware/sth-comet:$VER .
