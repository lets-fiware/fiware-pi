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
    -   [QuantumLeap](#quantumleap)
    -   [Perseo Core](#perseo-core)
    -   [Perseo FE](#perseo-fe)
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

To run FIWARE GEs using Docker on Raspberry Pi, we recommend using Raspberry Pi OS (Bullseye) or Ubuntu 22.04 LTS
(Jammy Jellyfish). You can install Raspberry Pi OS or Ubuntu using Raspberry Pi Imager. See the install instruction
[here](https://www.raspberrypi.com/software/).

## fiware-pi.git

Clone fiware-pi.git in your home directory.

```
sudo apt update
sudo apt install -y git
git clone https://github.com/lets-fiware/fiware-pi.git
```

## Docker

### How to install Docker on Raspberry Pi OS

You can install Docker Engine and Docker compose on Raspberry Pi OS by following the commands as shown:

```
cd build/docker/
./install-docker-on-debian.sh
```

The details to install Docker are [here](https://docs.docker.com/engine/install/debian/).

#### install script

```
#!/bin/sh
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

### How to install Docker on Ubuntu

You can install Docker Engine and Docker compose on Ubuntu by following the commands as shown:

```
cd build/docker/
./install-docker-on-ubuntu.sh
```

The details to install Docker are [here](https://docs.docker.com/engine/install/ubuntu/).

#### install script

```
#!/bin/sh
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

### How to run

Run the following command to confirm that docker engine has been successfully installed.

```
$ sudo docker version
Client: Docker Engine - Community
 Version:           24.0.6
 API version:       1.43
 Go version:        go1.20.7
 Git commit:        ed223bc
 Built:             Mon Sep  4 12:31:57 2023
 OS/Arch:           linux/arm64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          24.0.6
  API version:      1.43 (minimum version 1.12)
  Go version:       go1.20.7
  Git commit:       1a79695
  Built:            Mon Sep  4 12:31:57 2023
  OS/Arch:          linux/arm64
  Experimental:     false
 containerd:
  Version:          1.6.22
  GitCommit:        8165feabfdfe38c65b599c4993d227328c231fca
 runc:
  Version:          1.1.8
  GitCommit:        v1.1.8-0-g82f18fe
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
ksmainte@ubuntu243 (192.168.12.243):~/contribution/fiware-pi (update/documentation *) (0)
```

Run the following command to confirm that docker compose V2 has been successfully installed.

```
$ sudo docker compose version
Docker Compose version v2.21.0
```

# How to build and run FIWARE GEs

## Orion

### How to build Orion 

Run the following shell script to build Orion. The script includes some patches.

```
cd build/orion/orion-3.10.1
./build.sh
```

### How to run Orion

Start up Orion and mongodb with the following docker-compose.yml file.
The yml file is in build/orion/orion-3.10.1 directory.

```
version: "3"

services:
  orion:
    image: letsfiware/orion:3.10.1
    ports:
      - "1026:1026"
    depends_on:
      - mongo
    command: -dbhost mongo

  mongo:
    image: mongo:4.4
    command: --nojournal
```

Run the following command to confirm that Orion has been successfully built.

```
$ curl localhost:1026/version
{
"orion" : {
  "version" : "3.10.1",
  "uptime" : "0 d, 0 h, 0 m, 7 s",
  "git_hash" : "9a80e06abe7f690901cf1586377acec02d40e303",
  "compile_time" : "Thu Aug 10 10:20:17 UTC 2023",
  "compiled_by" : "root",
  "compiled_in" : "buildkitsandbox",
  "release_date" : "Thu Aug 10 10:20:17 UTC 2023",
  "machine" : "aarch64",
  "doc" : "https://fiware-orion.rtfd.io/en/3.10.1/",
  "libversions": {
     "boost": "1_74",
     "libcurl": "libcurl/7.74.0 OpenSSL/1.1.1n zlib/1.2.12 brotli/1.0.9 libidn2/2.3.0 libpsl/0.21.0 (+libidn2/2.3.0) libssh2/1.9.0 nghttp2/1.43.0 librtmp/2.3",
     "libmosquitto": "2.0.15",
     "libmicrohttpd": "0.9.76",
     "openssl": "1.1",
     "rapidjson": "1.1.0",
     "mongoc": "1.23.1",
     "bson": "1.23.1"
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
cd build/wirecloud/wirecloud1.3.1
./build.sh
```

### How to run WireCloud

Start up WireCloud with the `docker-compose.yml` file in `docker-wirecloud/1.3` directory.
Go to `http://localhost/` or `http://<your Pi's IP address>/`.

```
cd build/wirecloud/wirecloud1.3/docker-wirecloud/1.3
sudo docker-compose up -d
```

## Ngsiproxy

Run the following shell script to build Ngsiproxy.

```
cd build/ngsiproxy/ngsiproxy1.2.2
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

## IoT Agent for a UltraLight 2.0 based protocol

Run the following shell script to build IoT Agent UL.

```
cd build/iotagent-for-ul
./build.sh
```

## IoT Agent for JSON

Run the following shell script to build IoT Agent JSON.

```
cd build/iotagent-for-json
./build.sh
```

## QuantumLeap

Run the following shell script to build QuantumLeap.

```
cd build/quantumleap
./build.sh
```

## Perseo Core

Run the following shell script to build Perseo Core.

```
cd build/perseo-core
./build.sh
```

## Perseo FE

Run the following shell script to build Perseo FE.

```
cd build/perseo-fe
./build.sh
```

# Pre-Built FIWARE GEs Docker Images

-   [Orion 3.10.1](https://hub.docker.com/r/letsfiware/orion)
```
docker pull letsfiware/orion:3.10.1
```
-   [Orion-LD](https://hub.docker.com/r/fisuda/orion-ld)
```
docker pull fisuda/orion-ld:latest
```
-   [WireCloud 1.3.1](https://hub.docker.com/r/letsfiware/wirecloud)
```
docker pull letsfiware/wirecloud:1.3.1
```
-   [ngsiproxy 1.2.2](https://hub.docker.com/r/letsfiware/ngsiproxy)
```
docker pull letsfiware/ngsiproxy:1.2.2
```
-   [Keyrock 7.9.2](https://hub.docker.com/r/letsfiware/idm)
```
docker pull letsfiware/idm:7.9.2
```
-   [Wilma 7.9.2](https://hub.docker.com/r/letsfiware/pep-proxy)
```
docker pull letsfiware/pep-proxy:7.9.2
```
-  [Cygnus 3.2.0](https://hub.docker.com/r/letsfiware/fiware-cygnus)
```
docker pull letsfiware/fiware-cygnus:3.2.0
```
-  [sth-comet 2.10.0](https://hub.docker.com/r/letsfiware/sth-comet)
```
docker pull letsfiware/sth-comet:2.10.0
```
-  [iotagent-ul 2.3.0](https://hub.docker.com/r/letsfiware/iotagent-ul)
```
docker pull letsfiware/iotagent-ul:2.3.0
```
-  [iotagent-json 2.3.0](https://hub.docker.com/r/letsfiware/iotagent-json)
```
docker pull letsfiware/iotagent-json:2.3.0
```

-  [QuantumLeap](https://hub.docker.com/r/letsfiware/quantumleap)
```
docker pull letsfiware/quantumleap:latest
```

-  [Perseo Core 1.13.0](https://hub.docker.com/r/letsfiware/quantumleap)
```
docker pull letsfiware/perseo-core:1.13.0
```

-  [Perseo FE 1.27.0](https://hub.docker.com/r/letsfiware/quantumleap)
```
docker pull letsfiware/perseo-fe:1.27.0
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

Copyright (c) 2020-2023 Kazuhito Suda
Licensed under the MIT license.
