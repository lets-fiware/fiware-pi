#!/bin/sh
git clone https://github.com/telefonicaid/fiware-orion.git
cd fiware-orion/docker
docker build --build-arg GIT_REV_ORION=3.0.0 -t letsfiware/orion/3.0.0 .
