#!/bin/bash

PREFIX=/home/ubuntu/host

/usr/bin/env -i \
	PATH=$PREFIX/bin:$PATH \
	LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH \
	ACLOCAL_FLAGS="-I $PREFIX/share/aclocal" \
	PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH \
	CPPFLAGS=-I$PREFIX/include \
	LDFLAGS=-L$PREFIX/lib \
	\
	HOME=$HOME \
	TERM=$TERM \
	\
	DESTDIR=$PREFIX \
	\
	/bin/bash --rcfile <(cat ~/.bashrc ; echo 'PS1="\[\033[0;33m\][native x86]\[\033[00m\] $PS1"' ; echo 'alias cross=$HOME/cross-env.sh' ; echo $1) +h
