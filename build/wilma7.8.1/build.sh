#!/bin/sh
git clone -b 7.8.1 --depth=1 https://github.com/ging/fiware-pep-proxy.git
cd fiware-pep-proxy/extras/docker/
sudo docker build -t pep-proxy:7.8.1 .
sudo docker images | grep pep-proxy
