#!/bin/bash

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit 1
fi

PACKAGES="nginx curl wget"

for pkg in $PACKAGES
do

    if rpm -q $pkg &> /dev/null
    then
        echo "$pkg is already installed"

    else
        echo "Installing $pkg..."

        yum install -y $pkg

        echo "$pkg installed successfully"
    fi

done