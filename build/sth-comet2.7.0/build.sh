#!/bin/sh
git clone -b 2.7.0 --depth=1 https://github.com/telefonicaid/fiware-sth-comet.git
cd fiware-sth-comet/
sudo docker build -t sth-comet:2.7.0 .
