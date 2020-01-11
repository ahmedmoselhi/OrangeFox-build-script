# OrangeFox building script by SebaUbuntu
# You can find a list of all variables at OF_ROOT_DIR/vendor/recovery/orangefox_build_vars.txt
SCRIPT_VERSION="v2.1"
#!/bin/bash

# For clean environment
unset TARGET_DEVICE
unset TW_DEVICE_VERSION
unset BUILD_TYPE
unset TARGET_ARCH
unset OF_SCREEN_H
unset CLEAN_BUILD_NEEDED
clear

# AOSP enviroment setup
. build/envsetup.sh
clear

# OrangeFox logo function
NORMAL=$(tput sgr0)
REVERSE=$(tput smso)

logo() {
printf "${NORMAL}                                                                               ${REVERSE}\n"
printf "${NORMAL}                                          ${REVERSE}   ${NORMAL}                                  ${REVERSE}\n"
printf "${NORMAL}                                        ${REVERSE}     ${NORMAL}                                  ${REVERSE}\n"
printf "${NORMAL}                                        ${REVERSE}     ${NORMAL}                                  ${REVERSE}\n"
printf "${NORMAL}                                  ${REVERSE}   ${NORMAL}    ${REVERSE}      ${NORMAL}                                ${REVERSE}\n"
printf "${NORMAL}                                ${REVERSE}      ${NORMAL}    ${REVERSE}       ${NORMAL}                              ${REVERSE}\n"
printf "${NORMAL}                               ${REVERSE}         ${NORMAL}   ${REVERSE}       ${NORMAL}                             ${REVERSE}\n"
printf "${NORMAL}                               ${REVERSE}    ${NORMAL}          ${REVERSE}     ${NORMAL}                             ${REVERSE}\n"
printf "${NORMAL}                               ${REVERSE}          ${NORMAL}    ${REVERSE}   ${NORMAL}                               ${REVERSE}\n"
printf "${NORMAL}                                ${REVERSE}               ${NORMAL}                                ${REVERSE}\n"
printf "${NORMAL}                                 ${REVERSE}               ${NORMAL}                               ${REVERSE}\n"
printf "${NORMAL}                                 ${REVERSE}  ${NORMAL}  ${REVERSE}  ${NORMAL}    ${REVERSE} ${NORMAL} ${REVERSE}    ${NORMAL}                              ${REVERSE}\n"
printf "${NORMAL}                                 ${REVERSE}  ${NORMAL}  ${REVERSE}  ${NORMAL}    ${REVERSE}  ${NORMAL}  ${REVERSE}  ${NORMAL}                              ${REVERSE}\n"
printf "${NORMAL}                                 ${REVERSE}  ${NORMAL}  ${REVERSE}  ${NORMAL}     ${REVERSE} ${NORMAL}   ${REVERSE}  ${NORMAL}                             ${REVERSE}\n"
printf "${NORMAL}                                                                               \n"
printf "                           OrangeFox Recovery Project                          \n\n"
printf "                           Build script by SebaUbuntu                          \n\n"
printf "                                      $SCRIPT_VERSION                                      \n\n"
}

logo

# Ask user if a clean build is needed
printf "You want to do a clean build?\nAnswer: "
read CLEAN_BUILD_NEEDED
clear

logo

case $CLEAN_BUILD_NEEDED in
	  yes|y|true)
		printf "Deleting out/ dir, please wait...\n"
		make clean
		sleep 2
		clear
		;;
	*)
		printf "Clean build not required, skipping..."
		sleep 2
		clear
		;;
esac

logo

# what device are we building for?
printf "Insert the device codename you want to build for\nCodename: "
read TARGET_DEVICE
clear

logo

# Ask for release version
printf "Insert the version number of this release\nExample: R10.1\nVersion: "
read TW_DEVICE_VERSION
export TW_DEVICE_VERSION
clear

logo

# Ask for release type
printf "Insert the type of this release\nPossibilities: Stable - Beta - RC - Unofficial\nRelease type: "
read BUILD_TYPE
export BUILD_TYPE
clear

logo

# Export device-specific variables, remember to create a config file!
if [ -f config/$TARGET_DEVICE ]
	then
		for i in $(cat configs/$TARGET_DEVICE.ofconf)
			do
				export $i
			done
	else
		printf "Device-specific config not found! Create a config file as documented in GitHub repo. Exiting...\n\n"
		exit
fi

# TARGET_ARCH variable is needed by OrangeFox to determine which version of binary to include
if [ -z ${TARGET_ARCH+x} ]
	then
		printf "You didn't set TARGET_ARCH variable in config\n"
		exit
fi

# Define this value to fix graphical issues
if [ -z ${OF_SCREEN_H+x} ]
	then
		printf "You didn't set OF_SCREEN_H variable in config\nThis variable is needed to fix graphical issues on non-16:9 devices.\nEven if you have a 16:9 device, set it anyway."
		exit
fi

# Configure some default settings for the build

# For building with mimimal TWRP
export ALLOW_MISSING_DEPENDENCIES=true
export TW_DEFAULT_LANGUAGE="en"
# This fix build bug when locale is not "C"
export LC_ALL="C"
# To use ccache to speed up building
export USE_CCACHE="1"
# To use Magiskboot patching to have better compatibility with theming and avoid rebooting to fastboot
export OF_USE_MAGISKBOOT="1"
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES="1"
# Prevent issues like bootloop on encrypted devices
export OF_DONT_PATCH_ENCRYPTED_DEVICE="1"
# Try to decrypt data when a MIUI backup is restored
export OF_OTA_RES_DECRYPT="1"
# Include full bash shell
export FOX_USE_BASH_SHELL="1"
# Include nano editor
export FOX_USE_NANO_EDITOR="1"
# Modify this variable to your name
export OF_MAINTAINER="SebaUbuntu"
# A/B devices
[ "$OF_AB_DEVICE" = "1" ] && export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES="1"
# Enable ccache if declared
[ "$USE_CCACHE" = "1" ] && ccache -M 20G

# Lunch device
lunch omni_"$TARGET_DEVICE"-eng

# If lunch command fail, there is no need to continue building
if [ "$?" != "0" ]
	then exit
fi

# Start building
mka recoveryimage


