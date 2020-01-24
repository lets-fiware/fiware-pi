[![Let's FIWARE Banner](https://github.com/lets-fiware/fiware-pi/blob/gh-pages/img/lets-fiware-logo-non-free.png)](https://www.letsfiware.jp/)

[![License: MIT](https://img.shields.io/github/license/lets-fiware/fiware-pi.svg)](https://opensource.org/licenses/MIT)

The purpose of this project is to run FIWARE GEs on Raspberry Pi.

-   このドキュメントは[日本語](README.ja.md)でもご覧いただけます。

## Contents

<details>
<summary><strong>Details</strong></summary>

-   [What's FIWARE GEs on Raspberry Pi](#whats-fiware-ges-on-raspberry-pi)
-   [Prerequisites](#prerequisites)
    -   [Hardware](#hardware)
    -   [Ubuntu 19.10](#ubuntu-1910)
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
-   [Pre-Built FIWARE GEs Docker Images](#pre-built-fiware-ges-docker-images)

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

The target hardware is Raspberry Pi 4 with 4GB memory.

```
Hardware	: BCM2835
Revision	: c03112
Model		: Raspberry Pi 4 Model B Rev 1.2
```

## Ubuntu 19.10

To write OS image of Ubuntu 19.10 arm64 to a microSD card follow the instructions
[here](https://wiki.ubuntu.com/ARM/RaspberryPi)

```
xzcat ubuntu-19.10.1-preinstalled-server-arm64+raspi3.img.xz | sudo dd bs=4M of=/dev/mmcblk0
```

Set the microSD card to Raspberry pi, boot up Ubuntu and print the OS version.

```
ubuntu@ubuntu:~$ uname -a
Linux ubuntu 5.3.0-1014-raspi2 #16-Ubuntu SMP Tue Nov 26 11:18:23 UTC 2019 aarch64 aarch64 aarch64 GNU/Linux
```


## fiware-pi.git

Clone fiware-pi.git in your home directory.

```
sudo apt update
sudo apt install -y git
git clone https://github.com/lets-fiware/fiware-pi.git
```

## Docker Engine

### How to install

To install Docker on Linux basically follow the instructions
[here](https://docs.docker.com/install/linux/docker-ce/ubuntu/).
As the docker binary for Ubuntu 19.10 (Eoan) is not provided, it is necessary to install the docker binary
for Ubuntu 18.04 LTS (Bionic). Run the following script to install the docker engine.

```
cd build/docker-engine/
install-docker.sh
```

#### install script

```
#!/bin/bash
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
   bionic \
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
Run the following script to install the docker compose. The script includes a patch to avoid a build error.

```
cd build/docker-compose/
./build.sh
```

#### Build Script

```
#!/bin/bash
git clone -b 1.25.1 https://github.com/docker/compose.git
cd compose/
sed -i -e "43i'setuptools<45.0.0'," setup.py
sudo ./script/build/linux
sudo cp dist/docker-compose-Linux-aarch64 /usr/local/bin/docker-compose
docker-compose version
```

### How to run

Run the following command to confirm that docker compose has been successfully installed.

```
$ docker-compose version
docker-compose version 1.25.1, build cc93c976
docker-py version: 4.1.0
CPython version: 3.7.4
OpenSSL version: OpenSSL 1.1.0l  10 Sep 2019
```

# How to build and run FIWARE GEs

## Orion

### How to build Orion 

Run the following shell script to build Orion. The script includes some patches.

```
cd build/orion2.3.0
./biuld.sh
```

### How to run Orion

Start up Orion and mongodb with the following docker-compose.yml file.
The yml file is in build/orion2.3.0 directory.

```
version: "3"

services:
  orion:
    image: orion:2.3.0
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
Linux raspberrypi4 5.3.0-1015-raspi2 #17-Ubuntu SMP Thu Dec 5 04:58:47 UTC 2019 aarch64 aarch64 aarch64 GNU/Linux
$ curl localhost:1026/version
{
"orion" : {
  "version" : "2.3.0",
  "uptime" : "0 d, 0 h, 6 m, 13 s",
  "git_hash" : "764f44bff1e73f819d4e0ac52e878272c375d322",
  "compile_time" : "Sun Jan 19 04:41:20 UTC 2020",
  "compiled_by" : "root",
  "compiled_in" : "c6d3814adf4c",
  "release_date" : "Sun Jan 19 04:41:20 UTC 2020",
  "doc" : "https://fiware-orion.rtfd.io/en/2.3.0/"
}
}
```

## Orion-LD

### How to build Orion-LD

Run the following shell script to build Orion-LD.

```
cd build/orion-ld
./biuld.sh
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
cd build/wirecloud1.3
./biuld.sh
```

### How to run WireCloud

Start up WireCloud with the `docker-compose.yml` file in `docker-wirecloud/1.3` directory.
Go to `http://localhost/` or `http://<your Pi's IP address>/`.

```
cd build/wirecloud1.3/docker-wirecloud/1.3/
sudo docker-compose up -d
```

## Ngsiproxy

Run the following shell script to build Ngsiproxy.

```
cd build/ngsiproxy1.2.0
./biuld.sh
```

## Keyrock

Run the following shell script to build Keyrock.

```
cd build/keyrock7.8.1
./biuld.sh
```

## Wilma

Run the following shell script to build Wilma.

```
cd build/Wilma7.8.1
./biuld.sh
```

## Cygnus

Run the following shell script to build Cygnus.

```
cd build/cygnus1.17.1
./biuld.sh
```

## STH-Comet

Run the following shell script to build STH-Comet.

```
cd build/sth-comet2.7.0
./biuld.sh
```

## IoT Agent UL

Run the following shell script to build IoT Agent UL.

```
cd build/iotagent-ul1.12.0
./biuld.sh
```

# Pre-Built FIWARE GEs Docker Images

-   [Orion 2.3.0](https://hub.docker.com/r/fisuda/orion)
```
docker pull fisuda/orion:2.3.0
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
-   [Keyrock 7.8.1](https://hub.docker.com/r/fisuda/idm)
```
docker pull fisuda/idm:7.8.1
```
-   [Wilma 7.8.1](https://hub.docker.com/r/fisuda/pep-proxy)
```
docker pull fisuda/pep-proxy:7.8.1
```

## Copyright and License

Copyright (c) 2020 Kazuhito Suda
Licensed under the MIT license.
