#!/bin/bash

TOOLCHAIN=/home/ubuntu/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64
HOST=arm-linux-gnueabihf
SYSROOT=/home/ubuntu/sysroot

/usr/bin/env -i \
	PATH=$TOOLCHAIN/bin:$PATH \
	CC=$HOST-gcc \
	CXX=$HOST-g++ \
	AR=$HOST-ar \
	RANLIB=$HOST-ranlib \
	LD=$HOST-ld \
	\
	PKG_CONFIG_LIBDIR=$SYSROOT/usr/lib/pkgconfig \
	PKG_CONFIG_PATH=$SYSROOT/lib/pkgconfig \
	ACLOCAL_FLAGS="-I $SYSROOT/usr/share/aclocal" \
	CPPFLAGS="--sysroot=$SYSROOT" \
	LDFLAGS="--sysroot=$SYSROOT" \
	\
	SYSROOT=$SYSROOT \
	HOST=$HOST \
	DESTDIR=$SYSROOT \
	\
	HOME=$HOME \
	TERM=$TERM \
	\
	/bin/bash --rcfile <(cat ~/.bashrc ; echo 'PS1="\[\033[0;33m\][cross ARM]\[\033[00m\] $PS1"' ; echo $1)
