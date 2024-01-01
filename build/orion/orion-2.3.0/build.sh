#!/bin/sh
# Copyright (c) 2020-2024 Kazuhito Suda Licensed under the MIT license.

git clone -b 2.3.0 --depth=1 https://github.com/telefonicaid/fiware-orion.git
cd fiware-orion/docker/
sed -i -e 's/centos:centos7.6.1810/centos:7/' Dockerfile
sed -i -e 's/fiware\/orion/orion:2.3.0/' docker-compose.yml
docker build -t orion:2.3.0 .
