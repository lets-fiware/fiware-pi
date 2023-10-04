#!/bin/sh
VER=${1:-2.4.2}
DIR=iotagent-ul
if [ -e "${DIR}" ]; then
  rm -fr "${DIR}"
fi
git clone -b $VER --depth=1 https://github.com/telefonicaid/iotagent-ul.git
cd iotagent-ul/docker
docker build --no-cache --build-arg "DOWNLOAD=${VER}" -t letsfiware/iotagent-ul:$VER .
cd -
rm -fr "${DIR}"
