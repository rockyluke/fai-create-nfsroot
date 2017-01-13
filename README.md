# fai-create-nfsroot ![License badge][license-img] [![Build Status][build-img]][build-url]

## Overview

Debian is a free operating system (OS) for your computer. An operating system is
the set of basic programs and utilities that make your computer run.

[debian.org](https://www.debian.org/)

FAI is a  non-interactive system to install, customize and  manage Linux systems
and software configurations on computers as  well as virtual machines and chroot
environments, from  small networks to large-scale  infrastructures like clusters
and cloud environments.

[fai-project.org](http://fai-project.org/)

## Description

Use this script to build your own nfsroot base system.

## Usage

You first need  to choose which dist between lenny  (5.0), squeeze (6.0), wheezy
(7.0), jessie (8.0) and stretch (9.0) you want.

Create Debian 5.0 (lenny) nfsroot

```bash
$ fai-create-nfsroot.sh lenny
```

Create Debian 8.0 (jessie) nfsroot

```bash
$ fai-create-nfsroot.sh jessie
```

## Development

Feel free to contribute on GitHub.

```
    ╚⊙ ⊙╝
  ╚═(███)═╝
 ╚═(███)═╝
╚═(███)═╝
 ╚═(███)═╝
  ╚═(███)═╝
   ╚═(███)═╝
```

[license-img]: https://img.shields.io/badge/license-ISC-blue.svg
[build-img]: https://travis-ci.org/rockyluke/fai-create-nfsroot.svg?branch=master
[build-url]: https://travis-ci.org/rockyluke/fai-create-nfsroot
