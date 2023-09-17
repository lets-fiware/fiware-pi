#!/bin/sh
#VER=${1:-0.8.3}
if [ -e "ngsi-timeseries-api" ]; then
  rm -fr ngsi-timeseries-api
fi
# git clone -b $VER --depth=1 https://github.com/orchestracities/ngsi-timeseries-api.git
git clone --depth=1 https://github.com/orchestracities/ngsi-timeseries-api.git
cd ngsi-timeseries-api/
# docker build -t letsfiware/quantumleap:$VER .
docker build -t letsfiware/quantumleap:latest .
