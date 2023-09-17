#!/bin/sh
set -ue
VER=${1:-2.3.0}
DIR=iotagent-json
if [ "${DIR}" ]; then
  rm -fr "${DIR}"
fi
git clone -b $VER --depth=1 https://github.com/telefonicaid/iotagent-json.git
cd iotagent-json/docker
docker build --build-arg "DOWNLOAD=${VER}" -t letsfiware/iotagent-json:$VER .
cd -
rm -fr "${DIR}"
