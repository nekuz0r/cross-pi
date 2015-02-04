#!/bin/bash

PKG_NAME=rpi-3.18.y
PKG_URL=https://github.com/raspberrypi/linux/archive/${PKG_NAME}.tar.gz

pkg_build() {
	make mrproper
  make ARCH=${CROSSPI_HOST_ARCH} headers_check
}

pkg_install() {
	make ARCH=${CROSSPI_HOST_ARCH} INSTALL_HDR_PATH=dest headers_install
}

pkg_install_post() {
	find dest/include \( -name .install -o -name ..install.cmd \) -delete
  cp -rv dest/include/* $CROSSPI_TARGET_DIR/usr/include
}
