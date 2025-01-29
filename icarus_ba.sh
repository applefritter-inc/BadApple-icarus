#!/bin/sh

# most code taken from the inshim.sh payload from icarus.

mexit(){
	printf "$1"
	printf "exiting..."
	exit
}

[ "$EUID" -ne 0 ] && mexit "not root. (this shouldnt be happening, badapple gets a root shell.)"

get_largest_cros_blockdev() {
	local largest size dev_name tmp_size remo
	size=0
	for blockdev in /sys/block/*; do
		dev_name="${blockdev##*/}"
		echo -e "$dev_name" | grep -q '^\(loop\|ram\)' && continue
		tmp_size=$(cat "$blockdev"/size)
		remo=$(cat "$blockdev"/removable)
		if [ "$tmp_size" -gt "$size" ] && [ "${remo:-0}" -eq 0 ]; then
			case "$(sfdisk -d "/dev/$dev_name" 2>/dev/null)" in
				*'name="STATE"'*'name="KERN-A"'*'name="ROOT-A"'*)
					largest="/dev/$dev_name"
					size="$tmp_size"
					;;
			esac
		fi
	done
	echo -e "$largest"
}

format_part_number() {
	echo -n "$1"
	echo "$1" | grep -q '[0-9]$' && echo -n p
	echo "$2"
}

get_stateful() {
    cros_dev="$(get_largest_cros_blockdev)"
    if [ -z "$cros_dev" ]; then
		mexit "No CrOS SSD found on device. Failing."
    fi
    stateful=$(format_part_number "$cros_dev" 1)
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
	unmount /stateful
	crossystem disable_dev_request=1 || mexit "how did this shit even fail??"
	read -p "payload finished! enter to reboot"
	reboot -f
	mexit "should not have reached here. error occured."
}

main