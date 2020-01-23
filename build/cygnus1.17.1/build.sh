#!/bin/sh
git clone -b 1.17.1 --depth=1 https://github.com/telefonicaid/fiware-cygnus.git
cd fiware-cygnus/docker/cygnus-common/
sed -i -f ../../../cygnus.patch.txt Dockerfile
sudo docker build -t fisuda/cygnus-common:1.17.1 .
cd ../cygnus-ngsi/
sed -i -f ../../../cygnus.patch.txt Dockerfile
sudo docker build -t fisuda/cygnus-ngsi:1.17.1 .
cd ../cygnus-twitter/
sed -i -f ../../../cygnus.patch.txt Dockerfile
sudo docker build -t fisuda/cygnus-twitter:1.17.1 .
