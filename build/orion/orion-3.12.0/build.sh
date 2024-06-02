#!/bin/sh
VER=3.12.0
git clone -b ${VER} https://github.com/telefonicaid/fiware-orion.git
cd fiware-orion/docker
docker build --build-arg GIT_REV_ORION=${VER} -t letsfiware/orion:${VER} .
