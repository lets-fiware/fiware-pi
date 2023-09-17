#!/bin/sh
VER=${1:-1.13.0}
if [ -e "perseo-core" ]; then
  rm -fr perseo-core
fi
git clone -b $VER --depth=1 https://github.com/telefonicaid/perseo-core.git
cd perseo-core/
docker build -t letsfiware/perseo-core:$VER .
