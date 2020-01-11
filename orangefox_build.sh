# OrangeFox building script by SebaUbuntu
# You can find a list of all variables at OF_ROOT_DIR/vendor/recovery/orangefox_build_vars.txt
SCRIPT_VERSION="v1.2"
#!/bin/bash

# For clean environment
unset TARGET_DEVICE
unset TW_DEVICE_VERSION
unset BUILD_TYPE
unset TARGET_ARCH
unset OF_SCREEN_H
unset CLEAN_BUILD_NEEDED
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

# what device are we building for?
printf "You want to do a clean build? "y" for yes and "n" or press enter w/o typing anything for no\nAnswer: "
read CLEAN_BUILD_NEEDED
clear

logo

if [ $CLEAN_BUILD_NEEDED = "y" ]
	then
		printf "Deleting out/ dir, please wait...\n"
		make clean
		sleep 3
		clear
fi

logo

# what device are we building for?
printf "Insert the device codename you want to build for\nCodename: "
read TARGET_DEVICE
clear

logo

# Ask for release version
printf "Insert the version number of this release\nExample: R10.1\nVersion: "
read TW_DEVICE_VERSION
export TW_DEVICE_VERSION="$TW_DEVICE_VERSION"
clear

logo

# Ask for release type
printf "Insert the type of this release\nPossibilities: Stable - Beta - RC - Unofficial\nRelease type: "
read BUILD_TYPE
export BUILD_TYPE="$BUILD_TYPE"
clear

logo

# Export device-specific variables, remember to add them here!
if [ $TARGET_DEVICE = "whyred" ]
	then
		export TARGET_ARCH="arm64"
		export FOX_REPLACE_BUSYBOX_PS="1"
		export OF_ALLOW_DISABLE_NAVBAR="0"
		export OF_FLASHLIGHT_ENABLE="1"
		export OF_SCREEN_H="2160"
		export OF_STATUS_INDENT_LEFT="48"
		export OF_STATUS_INDENT_RIGHT="48"
elif [ $TARGET_DEVICE = "j4primelte" ]
	then
		export TARGET_ARCH="arm64"
		export OF_ALLOW_DISABLE_NAVBAR="0"
		export OF_FLASHLIGHT_ENABLE="1"
		export OF_SCREEN_H="2220"
		export OF_DONT_PATCH_ON_FRESH_INSTALLATION="1"
		export OF_DISABLE_MIUI_SPECIFIC_FEATURES="1"
elif [ $TARGET_DEVICE = "j4corelte" ]
	then
		export TARGET_ARCH="arm"
		export OF_ALLOW_DISABLE_NAVBAR="0"
		export OF_FLASHLIGHT_ENABLE="1"
		export OF_SCREEN_H="2220"
		export OF_DONT_PATCH_ON_FRESH_INSTALLATION="1"
		export OF_DISABLE_MIUI_SPECIFIC_FEATURES="1"
elif [ $TARGET_DEVICE = "j2y18lte" ]
	then
		export TARGET_ARCH="arm"
		export OF_FLASHLIGHT_ENABLE="1"
		export OF_SCREEN_H="1920"
		export OF_DONT_PATCH_ON_FRESH_INSTALLATION="1"
		export OF_DISABLE_MIUI_SPECIFIC_FEATURES="1"
else
		printf "Device-specific variables not found! Add them in script. Exiting...\n\n"
		exit
fi


if [ -z ${TARGET_ARCH+x} ]
	then
		printf "You didn't set TARGET_ARCH variable in script\n"
		exit
fi
if [ -z ${OF_SCREEN_H+x} ]
	then
		printf "You didn't set OF_SCREEN_H variable in script\nThis variable is needed to fix graphical issues on non-16:9 devices.\nEven if you have a 16:9 device, set it anyway."
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
# Try to decrypt data with MIUI
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

# AOSP enviroment setup
. build/envsetup.sh

# Lunch device
lunch omni_"$TARGET_DEVICE"-eng

# If lunch command fail, there is no need to continue building
if [ "$?" != "0" ]
	then exit
fi

# Start building
mka recoveryimage


