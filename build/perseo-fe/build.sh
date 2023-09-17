#!/bin/sh
VER=${1:-1.27.0}
if [ -e "perseo-fe" ]; then
  rm -fr perseo-fe
fi
git clone -b $VER --depth=1 https://github.com/telefonicaid/perseo-fe.git
cd perseo-fe/docker
docker build -t letsfiware/perseo-fe:$VER .
