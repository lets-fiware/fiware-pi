#!/bin/sh
VER=${1:-1.0.0}
if [ -e "ngsi-timeseries-api" ]; then
  rm -fr ngsi-timeseries-api
fi
git clone -b "${VER}" https://github.com/orchestracities/ngsi-timeseries-api.git
cd ngsi-timeseries-api/
docker build -t "letsfiware/quantumleap:${VER}" .
