#!/bin/sh
git clone -b 1.12.0 --depth=1 https://github.com/telefonicaid/iotagent-ul.git
cd iotagent-ul/docker
sudo docker build -t iotagent-ul:1.12.0 .
sudo docker images | grep iotagent-ul
