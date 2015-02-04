#!/bin/bash

get_home_directory() {
	SOURCE="${BASH_SOURCE[0]}"
	while [ -h "${SOURCE}" ]; do
  		DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
  		SOURCE="$(readlink "${SOURCE}")"
  		[[ $SOURCE != /* ]] && SOURCE="${DIR}/${SOURCE}"
	done
	DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"

	echo ${DIR}
}


CROSSPI_HOME=$(get_home_directory)

. ${CROSSPI_HOME}/lib/console
. ${CROSSPI_HOME}/lib/utils
. ${CROSSPI_HOME}/lib/cross-pi-utils
. ${CROSSPI_HOME}/lib/cross-pi-shells
. ${CROSSPI_HOME}/lib/cross-pi-scripts

crosspi_set_env
crosspi_check_root
crosspi_check_inception

case "$1" in
	init)
		exec ${CROSSPI_HOME}/bin/cross-pi-build-toolchain
		;;
	update)
		;;
	native)
		case "$2" in
			shell)
				crosspi_open_native_shell
				;;
			install)
				crosspi_run_native_script $3
				;;
			search)
				crosspi_search_native_script $3
				;;
			*)
				;;
		esac
		;;
	cross)
		case "$2" in
			shell)
				crosspi_open_cross_shell
				;;
			install)
				crosspi_run_cross_script $3
				;;
			search)
				crosspi_search_cross_script $3
				;;
			*)
				;;
		esac
		;;
	clean)
		;;
	save)
		;;
	restore)
		;;
	install)
		log_info_msg "Installing Cross-PI..."
		ln -sf $CROSSPI_HOME/cross-pi.sh /usr/local/bin/cross-pi &> /dev/null
		evaluate_retval
		;;
	uninstall)
		log_info_msg "Uninstall Cross-PI..."
		rm -f /usr/local/bin/cross-pi &> /dev/null
		evaluate_retval
		;;
	sysroot)
		;;
	chroot-target)
		sudo chroot ${CROSSPI_TARGET_DIR} /usr/bin/env -i HOME=/root TERM="$TERM" PS1='[chroot] \u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/sh --login
		;;
	*)
		echo "Usage: $0 {init|update|native|cross|clean|save|restore|install|uninstall}"
		;;
esac
