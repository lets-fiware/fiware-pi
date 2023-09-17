#!/bin/sh
set -ue

REPO=ngsi-proxy

if [ -e "${REPO}" ]; then
  rm -fr "${REPO}"
fi

git clone -b 1.2.2 --depth=1 "https://github.com/conwetlab/${REPO}.git"

cd ngsi-proxy/docker/
sudo docker build -t letsfiware/ngsiproxy:1.2.2 .
sudo docker images | grep letsfiware/ngsiproxy
