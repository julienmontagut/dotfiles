#!/bin/sh

# Checks if a command is installed
function check_installed() {
    COMMAND=$1
    if ! command -v $COMMAND &> /dev/null
    then
        echo "$COMMAND could not be found"
        exit
    fi
}

check_installed "lua"
