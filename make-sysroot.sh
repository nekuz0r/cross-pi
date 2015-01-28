#!/bin/bash

if [ -z "${1}" ]; then
	echo "no args"
	exit 1
fi

CROSSPI_HOME=$1
CROSSPI_TOOLS_DIR=$CROSSPI_HOME/tools
CROSSPI_SYSROOT_DIR=$CROSSPI_HOME/sysroot

if [ ! -d "$CROSSPI_TOOLS_DIR/.git" ]; then
	echo "no tools"
	exit 1
fi

if find "$CROSSPI_SYSROOT_DIR" -mindepth 1 -print -quit | grep -q .; then
	echo "sysroot not empty"
	exit 1
fi

TOOLCHAIN_ARM_DIR=$CROSSPI_TOOLS_DIR/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf

mkdir -p $CROSSPI_SYSROOT_DIR/{usr,lib}
mkdir -p $CROSSPI_SYSROOT_DIR/usr/{lib,include,local,libexec,share}

cp -R $TOOLCHAIN_ARM_DIR/lib/* $CROSSPI_SYSROOT_DIR/usr/lib/
cp -R $TOOLCHAIN_ARM_DIR/include/* $CROSSPI_SYSROOT_DIR/usr/include/

cp -R $TOOLCHAIN_ARM_DIR/libc/lib/arm-linux-gnueabihf $CROSSPI_SYSROOT_DIR/lib/

cp -R $TOOLCHAIN_ARM_DIR/libc/usr/include/* $CROSSPI_SYSROOT_DIR/usr/include/
mv $CROSSPI_SYSROOT_DIR/usr/include/arm-linux-gnueabihf/* $CROSSPI_SYSROOT_DIR/usr/include/
rm -Rf $CROSSPI_SYSROOT_DIR/usr/include/arm-linux-gnueabihf
cp -R $TOOLCHAIN_ARM_DIR/libc/usr/lib/arm-linux-gnueabihf $CROSSPI_SYSROOT_DIR/usr/lib/
cp -R $TOOLCHAIN_ARM_DIR/libc/usr/lib/locale $CROSSPI_SYSROOT_DIR/usr/lib/

exit 0
