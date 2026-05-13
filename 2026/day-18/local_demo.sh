#!/bin/bash

global_var="Global"

demo_function() {

    local local_var="Local"

    echo "Inside Function:"
    echo $local_var
    echo $global_var
}

demo_function

echo "Outside Function:"
echo $global_var

echo $local_var