#!/bin/bash

SERVICE="nginx"

read -p "Do you want to check the status? (y/n): " OPTION

if [ "$OPTION" == "y" ]; then

    systemctl status $SERVICE

    if systemctl is-active --quiet $SERVICE; then
        echo "$SERVICE is active"

    else
        echo "$SERVICE is not active"
    fi

else
    echo "Skipped."
fi