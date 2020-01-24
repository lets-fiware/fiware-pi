#!/bin/sh
git clone -b 1.13.0 --depth=1 https://github.com/telefonicaid/iotagent-json.git
cd iotagent-json/docker
sudo docker build -t iotagent-json:1.13.0 .
sudo docker images | grep iotagent-json
