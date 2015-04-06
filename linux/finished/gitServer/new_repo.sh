#!/bin/bash

if [[ $UID != 1001 ]]; then
    echo "Please run this script as git:"
    exit 1
fi

/bin/mkdir ~/$1.git
/bin/git init --bare ~/$1.git
