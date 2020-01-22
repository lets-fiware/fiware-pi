#!/bin/sh
git clone -b 7.8.1 --depth=1 https://github.com/ging/fiware-idm.git
cd fiware-idm/extras/docker/
sudo docker build -t idm:7.8.1 .
sudo docker images | grep idm
