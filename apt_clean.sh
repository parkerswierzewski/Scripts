#!/bin/bash
#
# Apt Clean v1.0
#
# author: Parker Swierzewski
# lanugage: Bash Script
# description: This program cleans the apt cache and updates missing folders. I ran into this error 
#               shortly after setting up my VM.
#
# Error:
#    E: Could not get lock /var/lib/dpkg/lock-frontend - open 
#       (11: Resource temporarily unavailable)
#    E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), 
#       is another process using it?

CYAN=`tput setaf 7`
YELLOW=`tput setaf 3`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
NC=`tput sgr0`

PROGRAM="${CYAN}apt_clean ${YELLOW}v1.0${NC}"

clear

printf "You are now running ${PROGRAM}\n\n"

if [ $(whoami) != "root" ]
then
	printf "${RED}This requires administrator level privileges${NC}!\n"
	printf "${RED}Execute 'sudo bash' and then 'bash apt_clean'${NC}!\n"
	exit 1
fi

printf "This script requires a reboot after completing\n"
printf "Should the script reboot for you? (y/n): "
read response

if [ $response == "y" ]
then
	printf "\nCleaning up system now ...\n"
	apt clean > /dev/null
	printf "Updating missing files ...\n"
	apt update --fix-missing > /dev/null
	fuser -vki /var/lib/dpkg/lock > /dev/null
	rm -f /var/lib/dpkg/lock > /dev/null
	printf "Reconfiguring /var/lib/dpkg/lock ...\n"
	dpkg --configure -a > /dev/null
	printf "${GREEN}System has been succesfully updated and reconfigured${NC}!\n"
	printf "Rebooting in 5 seconds ..."
	$(sleep 5)
	reboot
elif [ $response == "n" ]
then
	printf "\nCleaning up system now ...\n"
	apt clean > /dev/null
	printf "Updating missing files ...\n"
	apt update --fix-missing > /dev/null
	fuser -vki /var/lib/dpkg/lock > /dev/null
	rm -f /var/lib/dpkg/lock > /dev/null
	printf "Reconfiguring /var/lib/dpkg/lock ...\n"
	dpkg --configure -a > /dev/null
	printf "${GREEN}System has been successfully updated and reconfigured${NC}!\n"
	printf "Please reboot your machine to notices the changes.\n"
else
	printf "${RED}You did not enter a valid option re-run the script${NC}.\n"
	exit 1
fi
