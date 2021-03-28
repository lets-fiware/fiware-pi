#!/bin/sh
VER=${1:-1.18.3}
git clone -b $VER --depth=1 https://github.com/telefonicaid/fiware-cygnus.git
cd fiware-cygnus/docker/cygnus-common/
sed -i -f ../../../cygnus.patch.txt Dockerfile
docker build -t cygnus-common:$VER .
cd ../cygnus-ngsi/
sed -i -f ../../../cygnus.patch.txt Dockerfile
docker build -t cygnus-ngsi:$VER .
cd ../cygnus-twitter/
sed -i -f ../../../cygnus.patch.txt Dockerfile
docker build -t cygnus-twitter:$VER .
