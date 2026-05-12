#!/bin/bash
read -p "enter file name:" file
if [ -f "$file" ]; then
        echo " file exists"
else
        echo " file doesn't exists"
fi
