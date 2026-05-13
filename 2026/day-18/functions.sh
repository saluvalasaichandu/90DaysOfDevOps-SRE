#!/bin/bash
greet(){
        local name="$1"
        echo "hello $name"
}
add(){
        local num1="$1"
        local num2="$2"
        local result=$((num1+num2))
        echo " sum of ${num1} and ${num2} is: ${result}"

}

greet saichandu
greet devops engineer

add 10 20
add 50 200
