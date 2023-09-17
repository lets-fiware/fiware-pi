#!/bin/sh
set -ue

VER=${1:-3.2.0}
if [ -e "fiware-cygnus" ]; then
  rm -fr "fiware-cygnus"
fi
DOCKERFILE=docker/cygnus-ngsi/Dockerfile
git clone -b $VER --depth=1 https://github.com/telefonicaid/fiware-cygnus.git
cd fiware-cygnus/
sed -i -e "s/openjdk-amd64/openjdk-\${ARCH}/" "${DOCKERFILE}"
sed -i -e "275i \    if [ \$(uname -m) = "aarch64" ]; then ARCH="arm64"; else ARCH="amd64"; fi && \\\\" "${DOCKERFILE}"
docker build -f "${DOCKERFILE}" -t letsfiware/fiware-cygnus:$VER .
