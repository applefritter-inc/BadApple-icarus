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

## build a badapple icarus image
this is useless for the average user, only use this if you want to customize PKIMetadata or icarus_ba.sh

1. cd into the root directory of this repository
2. run `sudo ./image_create.sh`.
3. a image will be placed in the root directory of this repo called `icarus_ba.img`
it is an ext4 image that has an original size of 100MB, which is then shrinked to its minimum after adding PKIMetadata and icarus_ba.sh.
