#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
tar cvpjf /backup/backup-$(date +%Y%m%d%H%M).tar.bz2 --exclude=/proc --exclude=/lost+found --exclude=/backup --exclude=/mnt --exclude=/sys /


#Backup
#     tar cvpjf backup.tar.bz2 --exclude=/proc --exclude=/lost+found --exclude=/backup --exclude=/mnt --exclude=/sys /
#Restore
#     tar xvpfj backup.tar.bz2 -C /
#If the folders are missing create them
#     mkdir proc
#     mkdir lost+found
#     mkdir mnt
#     mkdir sys
#
#Website
#	https://help.ubuntu.com/community/BackupYourSystem/TAR
