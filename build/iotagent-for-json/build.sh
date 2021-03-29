#!/bin/sh
VER=${1:-1.17.0}
git clone -b $VER --depth=1 https://github.com/telefonicaid/iotagent-json.git
cd iotagent-json/docker
docker build --build-arg "DOWNLOAD=${VER}" -t iotagent-json:$VER .
