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

check_user_not_root() {
	if [ "$(id -u)" = "0" ]; then
		echo -e "${FAILURE}Error:${NORMAL} This action cannot be run as root !" 1>&2
		exit 1
	fi
}

check_inception() {
	if [ ! -z "$CROSSPI_SHELL" ]; then
		echo -e "${FAILURE}Error:${NORMAL} No cross-piception !" 1>&2
		exit 1
	fi
}

check_inception

export_env

sanity_check() {
	return 0
}

run_shell() {
	export CROSSPI_SHELL=$1
	exec $CROSSPI_HOME/shells/$CROSSPI_SHELL/shell.sh
}

case "$1" in
	init)
		download_raspberrypi_tools
		;;
	update)
		update_raspberrypi_tools
		;;
	native)
		run_shell "native"
		;;
	cross)
		run_shell "cross"
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
