[![Let's FIWARE Banner](https://github.com/lets-fiware/fiware-pi/blob/gh-pages/img/lets-fiware-logo-non-free.png)](https://www.letsfiware.jp/)

[![License: MIT](https://img.shields.io/github/license/lets-fiware/fiware-pi.svg)](https://opensource.org/licenses/MIT)

The purpose of this project is to run FIWARE GEs on Raspberry Pi.

-   このドキュメントは[日本語](https://www.letsfiware.jp/dev/fiware-pi/)でもご覧いただけます。

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [What's FIWARE GEs on Raspberry Pi](#whats-fiware-ges-on-raspberry-pi)
-   [Prerequisites](#prerequisites)
    -   [Hardware](#hardware)
    -   [Linux OS](#linux-os)
    -   [fiware-pi.git](#fiware-pigit)
    -   [Docker Engine](#docker-engine)
    -   [Docker Compose](#docker-compose)
-   [How to build and run FIWARE GEs](#how-to-build-and-run-fiware-ges)
    -   [Orion](#orion)
    -   [Orion-LD](#orion-ld)
    -   [WireCloud](#wirecloud)
    -   [Ngsiproxy](#ngsiproxy)
    -   [Keyrock](#keyrock)
    -   [Wilma](#wilma)
    -   [Cygnus](#cygnus)
    -   [STH-Comet](#sth-comet)
    -   [IoT Agent UL](#iot-agent-ul)
    -   [IoT Agent JSON](#iot-agent-json)
-   [Pre-Built FIWARE GEs Docker Images](#pre-built-fiware-ges-docker-images)
-   [Third-party Docker Images](#third-party-docker-images)
    -   [MySQL](#mysql)
    -   [Elasticsearch](#elasticsearch)

</details>

# What's FIWARE GEs on Raspberry Pi

> "I can show you the world."
>
> — A Whole New World (Aladdin)

The FIWARE GEs on Raspberry Pi is an **experimental** and **unofficial** project to run FIWARE GEs on the ARM
architecture. The [Raspberry Pi](https://www.raspberrypi.org/) is a low cost, credit-card sized computer.
It is an ARM based device and requires binaries compiled for the ARM architecture. In this project,
to build the docker image of GEs for the 64bit ARM architecture (aarch64), the 64bit Linux and docker are
installed on Raspberry Pi.

> :information_source: **Caution:** The official docker images of FIWARE GEs are supported on the x86_64 platform.
> The docker images for aarch64 are unofficial. If you encounter any error running the aarch64 docker images, you
> should clarify whether the error depends on aarch64 or not yourself. So, you should check if the error is
> reproduced on the x86_64 platform with the official image.

# Prerequisites

## Hardware

The target devices are Raspberry Pi 3 and 4 which support the 64 bit ARM architecture (aarch64).
For instance :

```
Hardware	: BCM2835
Revision	: c03112
Model		: Raspberry Pi 4 Model B Rev 1.2
```

### Linux OS

As of now, there are not many options to use the 64 bit Linux on Raspberry Pi. To use Ubuntu 20.04 LTS is
better. You can get the OS image and find the install instruction 
[here](https://ubuntu.com/download/raspberry-pi).


## fiware-pi.git

Clone fiware-pi.git in your home directory.

```
sudo apt update
sudo apt install -y git
git clone https://github.com/lets-fiware/fiware-pi.git
```

## Docker Engine

### How to install

You can install Docker on Ubuntu by following the commands as shown:

```
cd build/docker-engine/
sudo ./install-docker.sh
```

The details to install Docker are [here](https://docs.docker.com/install/linux/docker-ce/ubuntu/).


#### install script

```
sudo cp -p /etc/apt/sources.list{,.bak}
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install -y docker-ce
sudo docker version
```

### How to run

Run the following command to confirm that docker engine has been successfully installed.

```
ubuntu@ubuntu:~$ sudo docker version
Client: Docker Engine - Community
 Version:           19.03.5
 API version:       1.40
 Go version:        go1.12.12
 Git commit:        633a0ea
 Built:             Wed Nov 13 07:27:46 2019
 OS/Arch:           linux/arm64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.5
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.12.12
  Git commit:       633a0ea
  Built:            Wed Nov 13 07:26:16 2019
  OS/Arch:          linux/arm64
  Experimental:     false
 containerd:
  Version:          1.2.10
  GitCommit:        b34a5c8af56e510852c35414db4c1f4fa6172339
 runc:
  Version:          1.0.0-rc8+dev
  GitCommit:        3e425f80a8c931f88e6d94a8c831b9d5aa481657
 docker-init:
  Version:          0.18.0
  GitCommit:        fec3683
```


## Docker Compose

### How to install

The Docker Compose binary for aarch64 is not provided. It is necessary to build it from its source code.
Run the following script to install the docker compose.

```
cd build/docker-compose/
sudo ./build.sh
```

#### Build Script

```
#!/bin/bash
VERSION="${1:-1.27.4}"
git clone -b "$VERSION" https://github.com/docker/compose.git
cd compose/
./script/build/linux
cp dist/docker-compose-Linux-aarch64 /usr/local/bin/docker-compose
```

### How to run

Run the following command to confirm that docker compose has been successfully installed.

```
$ docker-compose version
docker-compose version 1.27.4, build 40524192
docker-py version: 4.3.1
CPython version: 3.7.7
OpenSSL version: OpenSSL 1.1.0l  10 Sep 2019
```

# How to build and run FIWARE GEs

## Orion

### How to build Orion 

Run the following shell script to build Orion. The script includes some patches.

```
cd build/orion/orion-2.6.0
./build.sh
```

### How to run Orion

Start up Orion and mongodb with the following docker-compose.yml file.
The yml file is in build/orion/orion2.6.0 directory.

```
version: "3"

services:
  orion:
    image: orion:2.6.0
    ports:
      - "1026:1026"
    depends_on:
      - mongo
    command: -dbhost mongo

  mongo:
    image: mongo:3.6
    command: --nojournal
```

Run the following command to confirm that Orion has been successfully built.

```
$ uname -a
Linux raspberrypi4 5.4.0-1032-raspi #35-Ubuntu SMP PREEMPT Fri Mar 19 20:52:40 UTC 2021 aarch64 aarch64 aarch64 GNU/Linux
$ curl localhost:1026/version
{
"orion" : {
  "version" : "2.6.0",
  "uptime" : "0 d, 0 h, 0 m, 9 s",
  "git_hash" : "1ac27e059e900f17fb31df25d5a9b8976a60dded",
  "compile_time" : "Sun Mar 28 01:05:00 UTC 2021",
  "compiled_by" : "root",
  "compiled_in" : "fc765dc4baf5",
  "release_date" : "Sun Mar 28 01:05:00 UTC 2021",
  "doc" : "https://fiware-orion.rtfd.io/en/2.6.0/",
  "libversions": {
     "boost": "1_53",
     "libcurl": "libcurl/7.29.0 NSS/3.53.1 zlib/1.2.7 libidn/1.28 libssh2/1.8.0",
     "libmicrohttpd": "0.9.70",
     "openssl": "1.0.2k",
     "rapidjson": "1.1.0",
     "mongodriver": "legacy-1.1.2"
  }
}
}
```

## Orion-LD

### How to build Orion-LD

Run the following shell script to build Orion-LD.

```
cd build/orion-ld
./build.sh
```

### How to run Orion-LD

Start up Orion-LD and mongodb with the following docker-compose.yml file.
The yml file is in build/orion-ld/context.Orion-LD/docker directory.

```
mongo:
  image: mongo:3.6
  command: --nojournal

orion:
  image: orion-ld
  links:
    - mongo
  ports:
    - "1026:1026"
  command: -dbhost mongo
```

Run the following command to confirm that Orion-LD has been successfully built.

```
$ uname -a
Linux raspberrypi4 5.3.0-1015-raspi2 #17-Ubuntu SMP Thu Dec 5 04:58:47 UTC 2019 aarch64 aarch64 aarch64 GNU/Linux
$ curl localhost:1026/ngsi-ld/ex/v1/version
{
  "Orion-LD version": "post-v0.1.0",
  "based on orion": "1.15.0-next",
  "kbase version": "0.2",
  "kalloc version": "0.2",
  "kjson version": "0.2",
  "boost version": "1_62",
  "microhttpd version": "0.9.48-0",
  "openssl version": "OpenSSL 1.1.0l  10 Sep 2019",
  "mongo version": "1.1.3",
  "rapidjson version": "1.0.2",
  "libcurl version": "7.52.1",
  "libuuid version": "UNKNOWN",
  "branch": "develop",
  "Next File Descriptor": 18
}
```

## WireCloud

### How to build WireCloud

Run the following shell script to build WireCloud.

```
cd build/wirecloud/wirecloud1.3
./build.sh
```

### How to run WireCloud

Start up WireCloud with the `docker-compose.yml` file in `docker-wirecloud/1.3` directory.
Go to `http://localhost/` or `http://<your Pi's IP address>/`.

```
cd build/wirecloud1.3/docker-wirecloud/1.3
sudo docker-compose up -d
```

## Ngsiproxy

Run the following shell script to build Ngsiproxy.

```
cd build/ngsiproxy/ngsiproxy1.2.0
./build.sh
```

## Keyrock

### How to build Keyrock

Run the following shell script to build Keyrock.

```
cd build/keyrock
./build.sh
```

### How to run Keyrock

Start up Keyrock with the `docker-compose.yml` file in `keyrock` directory.
Go to `http://localhost:3000/` or `http://<your Pi's IP address>:3000/`.

```
cd build/keyrock
sudo docker-compose up -d
```

## Wilma

Run the following shell script to build Wilma.

```
cd build/Wilma
./build.sh
```

## Cygnus

Run the following shell script to build Cygnus.

```
cd build/cygnus
./build.sh
```

## STH-Comet

Run the following shell script to build STH-Comet.

```
cd build/sth-comet
./build.sh
```

## IoT Agent UL

Run the following shell script to build IoT Agent UL.

```
cd build/iotagent-ul
./build.sh
```

## IoT Agent JSON

Run the following shell script to build IoT Agent JSON.

```
cd build/iotagent-json
./build.sh
```

# Pre-Built FIWARE GEs Docker Images

-   [Orion 2.4.0](https://hub.docker.com/r/fisuda/orion)
```
docker pull fisuda/orion:2.4.0
```
-   [Orion-LD](https://hub.docker.com/r/fisuda/orion-ld)
```
docker pull fisuda/orion-ld:latest
```
-   [WireCloud 1.3](https://hub.docker.com/r/fisuda/wirecloud)
```
docker pull fisuda/wirecloud:1.3
```
-   [ngsiproxy 1.2.0](https://hub.docker.com/r/fisuda/ngsiproxy)
```
docker pull fisuda/ngsiproxy:1.2.0
```
-   [Keyrock 7.9.2](https://hub.docker.com/r/letsfiware/idm)
```
docker pull letsfiware/idm:7.9.2
```
-   [Wilma 7.9.2](https://hub.docker.com/r/letsfiware/pep-proxy)
```
docker pull letsfiware/pep-proxy:7.9.2
```
-  [cygnus-common 1.18.3](https://hub.docker.com/r/fisuda/cygnus-common)
```
docker pull fisuda/cygnus-common:1.18.3
```
-  [cygnus-ngsi 1.18.3](https://hub.docker.com/r/fisuda/cygnus-ngsi)
```
docker pull fisuda/cygnus-ngsi:1.18.3
```
-  [cygnus-twitter 1.18.3](https://hub.docker.com/r/fisuda/cygnus-twitter)
```
docker pull fisuda/cygnus-twitter:1.18.3
```
-  [sth-comet 2.7.0](https://hub.docker.com/r/fisuda/sth-comet)
```
docker pull fisuda/sth-comet:2.7.0
```
-  [iotagent-ul 1.13.0](https://hub.docker.com/r/fisuda/iotagent-ul)
```
docker pull fisuda/iotagent-ul:1.13.0
```
-  [iotagent-json 1.14.0](https://hub.docker.com/r/fisuda/iotagent-json)
```
docker pull fisuda/iotagent-json:1.14.0
```

# Third-party Docker Images

## MySQL

### How to build MySQL

Run the following shell script to build MySQL 5.7.21.

```
cd build/third-party/mysql-5.7.21
./build.sh
```

## Elasticsearch

### How to build Elasticsearch

Run the following shell script to build Elasticsearch 2.4.

```
cd build/third-party/elasticsearch-2.4
./build.sh
```

## Copyright and License

Copyright (c) 2020 Kazuhito Suda
Licensed under the MIT license.
