#!/bin/bash

# Get functions: info, warn, error, exit_on_fail
source common.sh

# Check if running as root
if [ $(id -u) -ne 0 ]; then # https://stackoverflow.com/questions/18215973/how-to-check-if-running-as-root-in-a-bash-script
    error "Please run this script as root!"
    exit 1
fi

