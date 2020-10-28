# X205TAudio
A bash script for Linux that fixes the audio issues on the Asus Eeebook x205ta (chtrt5645 chipset). 

# About
While the script should be compatible with any linux distribution, it is intended for `Void Linux`. 
It has been tested on kernel version `5.8.16_1` and works flawlessly. 
The script downloads `alsa-lib-1.2.2` from the www.alsa-project.org webserver - it then extracts, compiles and installs the module with the appropriate use case manager (UCM) files.

# Prerequisites 
The following packages are needed for the script to function properly:
* `git` - version >= 2.29.0_1
* `wget` - version >= 1.20.3_3
* `libtool` - version >= 2.4.6_4


If used on VoidLinux, these can be installed as such:
```
sudo xbps-install -S git wget libtool

```

# Usage
The script needs to be ran as root, as follows:
```
git clone https://github.com/Borys64/X205TAudio
cd X205TAudio
sudo bash script.sh
```
# Credits
[alsa-lib-x205ta](https://aur.archlinux.org/packages/alsa-lib-x205ta/)  - ArchLinux AUR
