#!/bin/bash

/usr/bin/env \
	PATH=$CROSSPI_HOST_DIR/bin:$CROSSPI_HOST_DIR/usr/bin:$CROSSPI_HOST_DIR/usr/local/bin:$PATH \
	LD_LIBRARY_PATH=$CROSSPI_HOST_DIR/lib:$LD_LIBRARY_PATH \
	ACLOCAL_FLAGS="-I $CROSSPI_HOST_DIR/share/aclocal" \
	PKG_CONFIG_PATH="$CROSSPI_HOST_DIR/lib/pkgconfig,$PKG_CONFIG_PATH" \
        CPPFLAGS=-I$CROSSPI_HOST_DIR/include \
        LDFLAGS=-L$CROSSPI_HOST_DIR/lib \
        \
	DESTDIR=$CROSSPI_HOST_DIR \
	\
	/bin/bash --noprofile --rcfile $CROSSPI_HOME/shells/$CROSSPI_SHELL/bashrc +h
