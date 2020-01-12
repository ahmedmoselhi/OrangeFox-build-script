# OrangeFox ofconf generator by SebaUbuntu
SCRIPT_VERSION="R10.1"
#!/bin/bash

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
printf "                        OFCONFIG generator by SebaUbuntu                       \n\n"
printf "                                      $SCRIPT_VERSION                                      \n\n"
}

clear

logo
# Ask for device codename
printf "Device codename: "
read TARGET_DEVICE
clear

logo
# Ask for device codename
printf "Device architecture - Possibilities: ARM - ARM64 - x86\nAnswer: "
read TARGET_ARCH
clear

logo
# Ask for device resolution
printf "Device resolution\nInsert it in HEIGHTxWIDTH (eg. 2160x1080)\nAnswer: "
read DEVICE_RESOLUTION
clear

# OrangeFox screen height obtaining
IFS="x"
for i in $DEVICE_RESOLUTION
	do
		RESOLUTION_VALUE=$((RESOLUTION_VALUE+1))
		if [ ! $RESOLUTION_VALUE = "1" ]
			then
				RESOLUTION_W=$i
			else
				RESOLUTION_H=$i
		fi
done
IFS=" "
let "OF_SCREEN_H = $RESOLUTION_H / $RESOLUTION_W * 1080"
printf "\nObtained $OF_SCREEN_H from calculation"
clear

logo
# Ask for device partitioning
printf "Is this an A/B device? (system_a and system_b partitions)\nAnswer: "
read OF_AB_DEVICE
clear


logo
printf "Do you want to include nano editor when using terminal?\nAnswer: "
read FOX_USE_NANO_EDITOR
clear

# Export correct values if user have used other value then 1
IFS="
"
if [ -f orangefox_build_vars.txt ]
	then
		for i in $(cat orangefox_build_vars.txt)
		do
			if [ "$(printf '%s' "$i" | cut -c1)" != "#" ]
				then
					case ${!i} in
						yes|y|true|1)
						export $i=1
						;;
					*)
						export $i=0
						;;
					esac
			fi
		done
fi
IFS=" "


# Copy to a new file config variables
echo "# OrangeFox config file for $TARGET_DEVICE
# Config based on OrangeFox $SCRIPT_VERSION variables, support for newer versions can't be guaranteed
# Created by generate_ofconfig.sh at $(date)
TARGET_ARCH="$TARGET_ARCH"
DEVICE_RESOLUTION="$DEVICE_RESOLUTION"
OF_SCREEN_H="$OF_SCREEN_H"" > configs/"$TARGET_DEVICE"_ofconfig

IFS="
"

for i in $(cat orangefox_build_vars.txt) 
		do 
			if [ "$(printf '%s' "$i" | cut -c1)" != "#" ] 
				then 
					echo "$i=${!i}" >> configs/"$TARGET_DEVICE"_ofconfig
			fi 
		done

IFS=" "
