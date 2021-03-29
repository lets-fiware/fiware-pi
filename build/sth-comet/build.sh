#!/bin/sh
VER=${1:-2.8.0}
git clone -b $VER --depth=1 https://github.com/telefonicaid/fiware-sth-comet.git
cd fiware-sth-comet/
docker build -t sth-comet:$VER .
