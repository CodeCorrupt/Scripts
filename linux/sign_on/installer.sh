#!/bin/bash

## This is the installer to allow access to the site script within the PATH variable
## HOW TO RUN:
##		./installer.sh
##		Then exit out and log back in


echo "" >> ~/.bashrc
echo "# The path to the site script to allow easy access to terminals" >> ~/.bashrc
echo "#This allows the script to be called without pathing out the full name" >> ~/.bashrc
echo "PATH=$(dirname "$(readlink -f "$0")"):\$PATH" >> ~/.bashrc
echo "#This enables bash completion so you can tab complete the site name" >> ~/.bashrc
echo "source $(dirname "$(readlink -f "$0")")/site-comp" >> ~/.bashrc
echo "Added the script to the path in your ~/.bashrc. "
echo "Please log out and back in and you will be able to run site \\site code\\"
