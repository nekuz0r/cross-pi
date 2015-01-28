#!/bin/bash

HOST=arm-linux-gnueabihf

/usr/bin/env -i \
	PATH=$CROSSPI_TOOLCHAIN/bin:$PATH \
	CC=$HOST-gcc \
	CXX=$HOST-g++ \
	AR=$HOST-ar \
	RANLIB=$HOST-ranlib \
	LD=$HOST-ld \
	\
	PKG_CONFIG_LIBDIR="$CROSSPI_SYSROOT_DIR/usr/lib/pkgconfig,$CROSSPI_TARGET_DIR/usr/lib/pkgconfig" \
	PKG_CONFIG_PATH="$CROSSPI_SYSROOT_DIR/lib/pkgconfig,$CROSSPI_TARGET_DIR/lib/pkgconfig" \
	ACLOCAL_FLAGS="-I $CROSSPI_SYSROOT_DIR/usr/share/aclocal -I $CROSSPI_TARGET_DIR/usr/share/aclocal" \
	CPPFLAGS="--sysroot=$CROSSPI_SYSROOT_DIR -I$CROSSPI_TARGET_DIR/usr/include" \
	LDFLAGS="--sysroot=$CROSSPI_SYSROOT_DIR -L$CROSSPI_TARGET_DIR/lib -L$CROSSPI_TARGET_DIR/usr/lib" \
	\
	SYSROOT=$CROSSPI_SYSROOT_DIR \
	HOST=$CROSSPI_HOST \
	TARGET=$CROSSPI_TARGET \
	CROSS_COMPILE=$CROSSPI_HOST \
	CROSS=$CROSSPI_HOST \
	DESTDIR=$CROSSPI_TARGET_DIR \
	\
	CROSSPI_SHELL="cross" \
	\
	CROSSPI_HOME=$CROSSPI_HOME \
	CROSSPI_HOST_DIR=$CROSSPI_HOST_DIR \
	CROSSPI_SYSROOT_DIR=$CROSSPI_SYSROOT_DIR \
	CROSSPI_TARGET_DIR=$CROSSPI_TARGET_DIR \
	CROSSPI_TOOLS_DIR=$CROSSPI_TOOLS_DIR \
	CROSSPI_TOOLCHAIN=$CROSSPI_TOOLCHAIN \
	CROSSPI_BUILD=$CROSSPI_BUILD \
        CROSSPI_BUILD_ARCH=$CROSSPI_BUILD_ARCH \
        CROSSPI_HOST=$CROSSPI_HOST \
        CROSSPI_HOST_ARCH=$CROSSPI_HOST_ARCH \
        CROSSPI_TARGET=$CROSSPI_TARGET \
        CROSSPI_TARGET_ARCH=$CROSSPI_TARGET_ARCH \
	\
	HOME=$HOME \
	TERM=$TERM \
	\
	/bin/bash --rcfile <(cat ~/.bashrc ; echo 'PS1="\[\033[0;33m\][cross $CROSSPI_TARGET_ARCH]\[\033[00m\] $PS1"' ; echo $1)
