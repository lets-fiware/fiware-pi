#!/bin/sh
git clone --depth=1 https://github.com/FIWARE/context.Orion-LD.git
cd context.Orion-LD/docker/
sed -r -i -e 's/fiware\/(orion-ld)/\1/' docker-compose.yml
ln -s Dockerfile-debian Dockerfile
sudo docker build -t orion-ld .
sudo docker images | grep orion-ld
