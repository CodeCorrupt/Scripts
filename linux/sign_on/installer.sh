#!/bin/bash

## This is the installer to allow access to the site script within the PATH variable
## HOW TO RUN:
##		/tmp/sign_on/installer.sh
##		Then exit out and log back in


echo "" >> ~/.bashrc
echo "# The path to the site script to allow easy access to terminals" >> ~/.bashrc
echo 'PATH=/tmp/sign_on:$PATH' >> ~/.bashrc
