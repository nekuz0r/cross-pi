#!/bin/bash

get_self_directory() {
	SOURCE="${BASH_SOURCE[0]}"
	while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  		DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  		SOURCE="$(readlink "$SOURCE")"
  		[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
	done
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

	echo $DIR
}

CROSSPI_HOME=$(get_self_directory)

. $CROSSPI_HOME/lib/console-functions
. $CROSSPI_HOME/lib/cross-pi-utils
. $CROSSPI_HOME/lib/cross-pi-rpi-tools

export_env

sanity_check() {
	return 0
}

case "$1" in
	init)
		download_raspberrypi_tools
		;;
	update)
		update_raspberrypi_tools
		;;
	native)
		exec $CROSSPI_HOME/host-env.sh
		;;
	cross)
		exec $CROSSPI_HOME/host-env.sh $CROSSPI_HOME/cross-env.sh
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
		log_info_msg "Creating basic sysroot..."
		$CROSSPI_HOME/make-sysroot.sh $CROSSPI_HOME
		evaluate_retval
		;;
	*)
		echo "Usage: $0 {init|update|native|cross|clean|save|restore|install|uninstall}"
		;;
esac
