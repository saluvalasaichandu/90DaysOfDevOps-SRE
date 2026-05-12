#!/bin/bash
read -p "enter a number:" num
if [ $num -gt 0 ]; then
    echo "number is positive"
elif [ $num -lt 0 ]; then
    echo " number is negative"
else 
   echo "number is zero"
fi
