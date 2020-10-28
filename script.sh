#!/bin/bash 
function start {
	# Check if root
	if [ "$EUID" -ne 0 ]
	  then printf "\n| This script needs to be ran as root\n"
	  exit
	fi

	# Check if git exists
	if [ -e "/bin/git" ]
	then
		printf "\n| Found git\n"
	else
		printf "\n| This script requires git to function\n"
		return
	fi

	# Check for UCM files
	if [ -e "./ucm/HiFi.conf" ] && [ -e "./ucm/chtrt5645.conf" ]; then
		printf "\n| UCM files found\n"
	else
		printf "\n| UCM files not found please reclone the repository and run this script again\n"
		return
	fi	

	# Check if wget is installed
	if [ -e "/bin/wget" ]
	then
		printf "\n| Found wget\n"
	else 
		printf "\n| This script requires wget to function\n"
		return
	fi

	# Check if autoconf is installed
	if [ -e "/bin/autoreconf" ]
	then
		printf "\n| Found autoconf\n"
	else 
		printf "\n| This script requires autoconf to function\n"
		return
	fi

	# Check if autoconf is installed
	if [ -e "/bin/automake" ]
	then
		printf "\n| Found automake\n"
	else 
		printf "\n| This script requires automake to function\n"
		return
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
