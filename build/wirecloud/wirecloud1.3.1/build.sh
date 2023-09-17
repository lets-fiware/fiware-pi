#!/bin/sh
set -ue

REPO=docker-wirecloud

if [ -e "${REPO}" ]; then
  rm -fr "${REPO}"
fi

git clone --depth=1 "https://github.com/Wirecloud/${REPO}.git"

cd "${REPO}/1.3"
ls -1 *.yml | xargs -L 1 sed -i -e 's%fiware/wirecloud:1.3%letsfiware/wirecloud:1.3.1%'
ls -1 *.yml | xargs -L 1 sed -r -i -e 's/(elasticsearch:2\.4)/fisuda\/\1/'
sed -i "s/wirecloud<1.4/wirecloud==1.3.1/" Dockerfile
sudo docker build -t letsfiware/wirecloud:1.3.1 .
sudo docker images | grep letsfiware/wirecloud:1.3.1
