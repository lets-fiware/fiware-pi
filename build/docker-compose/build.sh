#!/bin/bash
git clone -b 1.25.1 https://github.com/docker/compose.git
cd compose/
sed -i -e "43i'setuptools<45.0.0'," setup.py
sudo ./script/build/linux
sudo cp dist/docker-compose-Linux-aarch64 /usr/local/bin/docker-compose
docker-compose version
