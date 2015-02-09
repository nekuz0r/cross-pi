#!/bin/bash

. /home/ubuntu/cross-pi/lib/console
. /home/ubuntu/cross-pi/lib/utils

fuse_grp_id() {
	local FUSE_GRP_ID=
	local OLD_IFS=${IFS}
	IFS=$':'
	while read name special id users
	do
		if [ "$name" = "fuse" ]; then
			FUSE_GRP_ID=$id
			break
		fi
	done < /etc/group
	IFS=${OLD_IFS}
	echo ${FUSE_GRP_ID}
}

is_user_in_fuse_grp() {
	local FUSE_GRP_ID=$(fuse_grp_id)
	for GROUP in ${GROUPS[*]}
	do
		if [ "${GROUP}" -eq "${FUSE_GRP_ID}" ]; then
			return 0
		fi
	done
	return 1
}

check_fuse() {
	[ -f "/dev/fuse" ]
}

check_binfmt_misc() {
	log_info_msg "Checking binfmt_misc mounted on /proc/sys/fs/binfmt_misc ..."
	[ -f "/proc/sys/fs/binfmt_misc/status" ]
	evaluate_retval || exit 1

	log_info_msg "Checking binfmt_misc enabled ..."
	[ $(cat "/proc/sys/fs/binfmt_misc/status") = "enabled" ]
	evaluate_retval || exit 1

	log_info_msg "Checking arm registered ..."
	[ -f "/proc/sys/fs/binfmt_misc/arm" ]
	evaluate_retval || exit 1

	log_info_msg "Checking arm enabled ..."
	local ARM_STATUS=($(cat "/proc/sys/fs/binfmt_misc/arm"))
	[ "${ARM_STATUS[0]}" = "enabled" ]
	evaluate_retval
}

# adduser $USER fuse
# sudo mknod /dev/fuse c 10 229
# sudo chgrp fuse /dev/fuse
# sudo chmod g+rw /dev/fuse

check_binfmt_misc
