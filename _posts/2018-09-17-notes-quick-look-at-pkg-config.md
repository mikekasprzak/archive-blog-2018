---
title: 'Notes: Quick look at pkg-config'
layout: post
date: '2018-09-17 21:24:11'
---

[https://autotools.io/pkgconfig/cross-compiling.html](https://autotools.io/pkgconfig/cross-compiling.html)

Standard wrapper:

```bash
#!/bin/sh

SYSROOT=/build/root

export PKG_CONFIG_DIR=
export PKG_CONFIG_LIBDIR=${SYSROOT}/usr/lib/pkgconfig:${SYSROOT}/usr/share/pkgconfig
export PKG_CONFIG_SYSROOT_DIR=${SYSROOT}

exec pkg-config "$@"
```

Notably `PKG_CONFIG_LIBDIR` needed to be set before it actually worked for me (otherwise it kept finding the stuff in my linux install).

I mistakenly thought you'd have to install pkg-config in to each toolchain, but I was wrong. You just need a smart script.

```bash
ROOT=~/android/ndk-arm
SYSROOT=${ROOT}/sysroot
INSTALL_PREFIX=${SYSROOT}/usr/local/

TARGET=arm-linux-androideabi
HOST=armv7a-none-linux-android
TOOL_PREFIX=${ROOT}/bin/

export CC="${TOOL_PREFIX}clang"
export AR="${TOOL_PREFIX}llvm-ar"
export LD="${TOOL_PREFIX}${TARGET}-ld"

export PKG_CONFIG_DIR=
export PKG_CONFIG_LIBDIR=${SYSROOT}/usr/lib/pkgconfig:${SYSROOT}/usr/share/pkgconfig
export PKG_CONFIG_SYSROOT_DIR=${SYSROOT}

../SDL/configure --host=$HOST --prefix=$INSTALL_PREFIX --with-sysroot=$SYSROOT --disable-shared
```

Work in progress.