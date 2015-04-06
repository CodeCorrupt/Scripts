#!/bin/bash

if [[ $UID != 1001 ]]; then
    echo "Please run this script as git:"
    exit 1
fi

rm -rf ~/$1.git