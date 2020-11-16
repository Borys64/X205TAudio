#!/bin/bash 
function start {
	
	# Check for dependencies
	printf "This script requires the following dependencies:\ngit - version >= 2.29.0_1\nwget - version >= 1.20.3_3\nznlibtool - version >= 2.4.6_4\n"
	printf "Please type 'yes' if you have installed all required distro equivalent packages: "
	read answer

	if [ answer = "yes" ]
		then exit
	fi

	# Check if root
	if [ "$EUID" -ne 0 ]
	  then printf "\n| This script needs to be ran as root\n"
	  exit
	fi

	# Make build directory
	printf "\n| Creating build directory\n"
	mkdir build

	# Get alsa files
	cd build
	printf "\n| Downloading alsa-lib-1.2.2.tar.bz2\n"
	wget https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.2.tar.bz2 -q -O alsa-lib-1.2.2.tar.bz2

	# Extract alsa
	printf "\n| Extracting alsa-lib-1.2.2.tar.bz2\n"
	tar -xjf ./alsa-lib-1.2.2.tar.bz2

	# Change directory
	cd alsa-lib-1.2.2

	# Prepare
	printf "\n| Running autoreconf\n"
	autoreconf -vfi

	# Configure
	printf "\n| Configuring\n"
	./configure --prefix=/usr --without-debug

	# Build
	printf "\n| Building module\n"
	make

	# Install
	printf "\n| Installing module\n"
	make DESTDIR="$pkgdir" install -C doc
	make DESTDIR="$pkgdir/" install
	libtool --finish /usr/lib

	# Copy over UCM files
	printf "\n| Copying UCM files\n"
	cp "../../ucm/HiFi.conf" "/usr/share/alsa/ucm/chtrt5645/HiFi.conf"
	cp "../../ucm/chtrt5645.conf" "/usr/share/alsa/ucm/chtrt5645/chtrt5645.conf"

	printf "\n| Finished copying files, restarting alsa\n"
	alsactl restore

	# Clean
	printf "\n| Cleaning\n"
	cd ../../
	rm ./build -rf
	
	printf "\n| It is reccomended that you reboot the system after an installation to ensure that all changes have been applied\n"
}

start
