#!/bin/sh
# Copyright (c) 2020 Kazuhito Suda Licensed under the MIT license.

git clone -b 2.3.0 --depth=1 https://github.com/telefonicaid/fiware-orion.git
cd fiware-orion/docker/
sed -i -e '31r../../patch-scons.txt' Dockerfile
sed -i -f '../../patch-Dockerfile.txt' Dockerfile
sed -i -e 's/fiware\/orion/orion:2.3.0/' docker-compose.yml
sudo docker build -t orion:2.3.0 .
sudo docker images | grep orion
