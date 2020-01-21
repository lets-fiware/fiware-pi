#!/bin/sh
git clone --depth=1 https://github.com/Wirecloud/docker-wirecloud.git
cd docker-wirecloud/1.3
ls -1 *.yml | xargs sed -r -i -e 's/fiware\/(wirecloud:1\.3)/\1/'
ls -1 *.yml | xargs sed -r -i -e 's/(elasticsearch:2\.4)/fisuda\/\1/'
sudo docker build -t wirecloud:1.3 .
sudo docker images | grep wirecloud:1.3
