#!/bin/sh
VER=${1:-1.16.0}
git clone -b $VER --depth=1 https://github.com/telefonicaid/iotagent-ul.git
cd iotagent-ul/docker
docker build --no-cache --build-arg "DOWNLOAD=${VER}" -t iotagent-ul:$VER .
