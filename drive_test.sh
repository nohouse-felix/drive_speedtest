#!/bin/bash



# Check if script runs as root
if ! [[ `whoami` == "root" ]]
	then
	is_root=0
	echo -e "\nThis script has to be executed as root. Aborting..."
	exit 1

elif [[ `whoami` == "root" ]]
	then
	is_root=1
	echo -e "\nINFO: User is root. Proceeding..."
	
else
	echo -e "\Unexpected behavior. Aborting..."
	exit 1
	
fi



# Check if package 'hdparm' is present in current system environment
if [[ $(ls /usr/sbin | grep hdparm) == "" ]]
	then
	is_installed=0
	echo -e "\nWARN: Required package 'hdparm' is not installed."
	sleep 3

	echo -e "\nDo you want to install it? (y/n): "

	install_dec=0
	while [[ $install_dec -lt 1 ]]
	do

		read install_prompt

		if [[ $install_prompt == "y" ]] || [[ $install_prompt == "Y" ]]
			then
			echo -e "\nINFO: Refreshing repositories...\n"
			sleep 2
			apt update
			echo -e "\nInstalling hdparm...\n"
			sleep 2
			apt install hdparm -y
			sleep 2
			is_installed=1
			install_dec=1

		elif [[ $install_prompt == "n" ]] || [[ $install_prompt == "N" ]]
			then
			echo -e "\nINFO: Required package 'hdparm' will not be installed. Aborting..."
			install_dec=1
			exit 1
			
		else
			echo -e "\nWARN: Invalid input, please try again.\nDo you want to install 'hdparm'? (y/n):"

		fi
	
	done

else
	echo -e "\nINFO: Required package 'hdparm' seems to be installed. Proceeding..."
	sleep 2

fi



# List all block devices present in current system environment
echo -e "\n####################################################\nDrives currently present on your system:\n"
lsblk
block_devices=$(lsblk)




# Ask user for device path and check if it exists
device_prompt=0
while [[ $device_prompt -lt 1 ]]
do
	echo -e "\nEnter the name of the device to be tested e.g. /dev/sdx: "
	read device_path
	device=$(echo $device_path | cut -d/ -f 3)

	if [[ $block_devices == *$device* ]] && [[ $device_path == "/dev/"* ]] && [[ ls /dev | grep $device != "" ]]
		then
		echo -e "\nINFO: Device found, starting tests..."
		device_prompt=1

	else
		echo -e "\nWARN: The specified drive is not present on your system. Please try again: "
		
	fi
done



# Save result of hdparm execution to variable
first_result=$(hdparm -t $device_path | grep Timing | cut -d= -f 2 | sed "s/ MB.*//")
echo -e "\n1st Test	-> $first_result MB/s"
echo -e "\nINFO: Waiting 10 seconds before performing next test."
sleep 10



# Save result of hdparm execution to variable
second_result=`hdparm -t $device_path | grep Timing | cut -d= -f 2 | sed "s/ MB.*//"`
echo -e "\n2nd Test	-> $second_result MB/s"
echo -e "\nINFO: Waiting 10 seconds before performing next test."
sleep 10



# Save result of hdparm execution to variable
third_result=`hdparm -t $device_path | grep Timing | cut -d= -f 2 | sed "s/ MB.*//"`
echo -e "\n3rd Test	-> $third_result MB/s"
sleep 2



# Print success message
echo -e "\n####################################################\nTest finished."
sleep 2



# Calculate result
mittelwert=$(awk "BEGIN {printf \"%.2f\n\", ($first_result + $second_result + $third_result)/3}")



# Print result
echo -e "\nAverage read speed of device '$device_path': $mittelwert MB/s"
