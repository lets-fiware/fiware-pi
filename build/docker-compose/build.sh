#!/bin/bash
VERSION="${1:-1.25.4}"
git clone -b "$VERSION" https://github.com/docker/compose.git
cd compose/
./script/build/linux
cp dist/docker-compose-Linux-aarch64 /usr/local/bin/docker-compose
