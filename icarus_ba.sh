#!/bin/sh

# some code taken from the inshim.sh payload from icarus.

mexit(){
	printf "$1"
	printf "exiting..."
	exit
}

get_stateful() {
	# get_largest_cros_blockdev does not work in BadApple.
	local ROOTDEV_LIST=$(cat /usr/sbin/write_gpt.sh | grep -w "DEFAULT_ROOTDEV" | head -n 1 | sed -E 's/^.*DEFAULT_ROOTDEV="([^"]+)".*$/\1/')
    if [ -z "$ROOTDEV_LIST" ]; then
		mexit "could not parse for rootdev devices. this should not have happened."
    fi
    for rootdev_device in $ROOTDEV_LIST;
	do
		local device_list=$(ls $rootdev_device 2> /dev/null)
		local returncode=$?
		[ "$returncode" -eq 1 ] && continue
		# grep for host, nvme and mmc
		local device_type=$(echo "$rootdev_device" | grep -oE 'mmc|nvme|host' | head -n 1)
		case $device_type in
		"mmc")
			stateful=/dev/mmcblk0p1
			break
			;;
		"nvme")
			stateful=/dev/nvme0n1
			break
			;;
		"host")
			stateful=/dev/sda1
			break
			;;
		*)
			mexit "an unknown error occured. this should not have happened."
			;;
		esac
	done
}

does_out_exist() {
    [ ! -d "/icarus/PKIMetadata" ] && mexit "out directory not in usb stick. this should NOT happen."
}

wipe_stateful(){
    mkfs.ext4 -F "$stateful" || mexit "failed to wipe stateful, what happened?"
    mount "$stateful" /stateful || mexit "failed to mount, what happened?"
    mkdir -p /stateful/unencrypted
}

move_out_to_stateful(){
    cp /icarus/PKIMetadata /stateful/unencrypted/ -rvf
    chown 1000 /stateful/unencrypted/PKIMetadata -R
}

main() {
	does_out_exist
	get_stateful
	wipe_stateful
	move_out_to_stateful
	umount /stateful
	crossystem disable_dev_request=1 || mexit "how did this shit even fail??"
	read -p "payload finished! enter to reboot. you will boot into verified mode."
	reboot -f
	echo "should not have reached here. error occured."
	exit
}

main