#!/bin/bash

info () { echo -e "\e[32m[INFO]\e[0m ${1}" ; }
warn () { echo -e "\e[33m[WARN]\e[0m ${1}" ; }
error () { echo -e "\e[31m[ERROR]\e[0m ${1}" ; }

exit_on_fail () {
    exit_code=$?
    exit_message="$1"

    if [ $exit_code -ne 0 ]; then
        error "$exit_message"
        warn "Exiting the script"
        exit $exit_code
    fi
}
