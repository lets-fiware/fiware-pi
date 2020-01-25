#!/bin/sh
docker build -t elasticsearch:2.4 .
docker images | grep elasticsearch

