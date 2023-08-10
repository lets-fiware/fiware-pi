#!/bin/sh
git clone https://github.com/telefonicaid/fiware-orion.git
cd fiware-orion/docker
docker build --build-arg GIT_REV_ORION=3.10.1 -t letsfiware/orion:3.10.1 .
