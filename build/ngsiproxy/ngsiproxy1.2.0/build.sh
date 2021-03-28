#!/bin/sh
git clone -b 1.2.0 --depth=1 https://github.com/conwetlab/ngsi-proxy.git
cd ngsi-proxy/docker/
sudo docker build -t ngsiproxy:1.2.0 .
sudo docker images | grep ngsiproxy
