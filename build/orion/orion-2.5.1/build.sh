#!/bin/sh
git clone https://github.com/telefonicaid/fiware-orion.git
cd fiware-orion/docker
docker build --build-arg IMAGE_TAG=centos7 --build-arg GIT_REV_ORION=2.5.1 -t orion:2.5.1 .
