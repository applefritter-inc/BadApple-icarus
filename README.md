# icarus but for badapple
pretty straightforward process. this acts as a way to execute the icarus payload initally meant to be executed in shims. \
BadApple is an exploit to gain ACE(arbitary code execution) as root in developer mode whilst enterprise enrolled. SH1mmer does the same thing, but some boards have been keyrolled.

## steps
1. from the Releases page of this repository, download the image provided, which is named `icarus_ba.img`
2. use chromebook recovery utility or balenaEtcher or dd or your preferred usb flashing tool to flash the image to a thumbdrive
3. use BadApple to obtain a shell
4. plug in the usb stick with the flashed image
5. find the usb stick identifier with `fdisk -l` 
6. mount the image with `mkdir /icarus && mount /dev/sdX /icarus`, where `X` is your usb identifier, e.g. `/dev/sda`
7. now, to execute the icarus payload, run `cd /icarus && ./icarus_ba.sh`