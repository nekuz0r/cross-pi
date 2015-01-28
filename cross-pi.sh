#!/bin/bash

# Find current screen size
if [ -z "${COLUMNS}" ]; then
	COLUMNS=$(stty size)
	COLUMNS=${COLUMNS##* }
fi

if [ "${COLUMNS}" = 0 ]; then
	COLUMNS=80
fi

COL=$((${COLUMNS} - 8))
WCOL=$((${COL} - 2))

SET_COL="\\033[${COL}G"
SET_WCOL="\\033[${WCOL}G"
CURS_UP="\\033[1A\\033[0G"
CURS_ZERO="\\033[0G"

NORMAL="\\033[0;39m"
SUCCESS="\\033[1;32m"
WARNING="\\033[1;33m"
FAILURE="\\033[1;31m"
INFO="\\033[1;36m"
BRACKET="\\033[1;33m"

BMPREFIX="     "
SUCCESS_PREFIX="${SUCCESS}  *  ${NORMAL}"
FAILURE_PREFIX="${FAILURE}*****${NORMAL}"
WARNING_PREFIX="${WARNING} *** ${NORMAL}"

SUCCESS_SUFFIX="${BRACKET}[${SUCCESS}  OK  ${BRACKET}]${NORMAL}"
FAILURE_SUFFIX="${BRACKET}[${FAILURE} FAIL ${BRACKET}]${NORMAL}"
WARNING_SUFFIX="${BRACKET}[${WARNING} WARN ${BRACKET}]${NORMAL}"

log_success_msg() {
	echo -n -e "${BMPREFIX}${@}"
	echo -e "${CURS_ZERO}${SUCCESS_PREFIX}${SET_COL}${SUCCESS_SUFFIX}"
	return 0
}

log_failure_msg() {
        echo -n -e "${BMPREFIX}${@}"
        echo -e "${CURS_ZERO}${FAILURE_PREFIX}${SET_COL}${FAILURE_SUFFIX}"
        return 0
}

log_warning_msg() {
        echo -n -e "${BMPREFIX}${@}"
        echo -e "${CURS_ZERO}${WARNING_PREFIX}${SET_COL}${WARNING_SUFFIX}"
        return 0
}

log_info_msg() {
        echo -n -e "${BMPREFIX}${@}"
        return 0
}

evaluate_retval() {
	local error_value="${?}"

	if [ ${error_value} = 0 ]; then
		log_success_msg
	else
		log_failure_msg
	fi
}

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

export_env() {
	export CROSSPI_HOME=$CROSSPI_HOME
	export CROSSPI_HOST_DIR=$CROSSPI_HOME/host
	export CROSSPI_SYSROOT_DIR=$CROSSPI_HOME/sysroot
	export CROSSPI_TARGET_DIR=$CROSSPI_HOME/target
	export CROSSPI_SOURCES_DIR=$CROSSPI_HOME/sources
	export CROSSPI_TOOLS_DIR=$CROSSPI_HOME/tools

	if [ host_is_x64 ]; then
		TOOLCHAIN_SUFFIX="-x64"
	fi
	export CROSSPI_TOOLCHAIN=$CROSSPI_TOOLS_DIR/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian$TOOLCHAIN_SUFFIX
}

host_is_x64() {
	MACHINE_TYPE=`uname -m`
	if [ ${MACHINE_TYPE} == 'x86_64' ]; then
		return 1
	fi
	return 0
}

download_raspberrypi_tools() {
	if [ ! -d "$CROSSPI_HOME/tools/.git" ]; then
		log_info_msg "Downloading RPI cross-compilation tools..."
		git clone https://github.com/raspberrypi/tools.git &> /dev/null
		evaluate_retval
	fi
}

update_raspberrypi_tools() {
	log_info_msg "Updating RPI cross-compilation tools..."
	if [ ! -d "$CROSSPI_HOME/tools/.git" ]; then
		log_info_msg "\n"
		log_failure_msg "Can't update, tools not installed !"
		exit 1
	fi

	cd $CROSSPI_HOME/tools/
	git reset --hard &> /dev/null
	git clean -fd &> /dev/null
	git pull &> /dev/null
	evaluate_retval
	cd $CROSSPI_HOME
}

sanity_check() {
	return 0
}

CROSSPI_HOME=`get_self_directory`
cd $CROSSPI_HOME

case "$1" in
	init)
		download_raspberrypi_tools
		;;
	update)
		update_raspberrypi_tools
		;;
	native)
		export_env
		exec $CROSSPI_HOME/host-env.sh
		;;
	cross)
		export_env
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
