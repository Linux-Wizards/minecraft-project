#!/bin/bash

info () { echo -e "\e[32m[INFO]\e[0m ${1}" ; }
warn () { echo -e "\e[33m[WARN]\e[0m ${1}" ; }
error () { echo -e "\e[31m[ERROR]\e[0m ${1}" ; }

# First argument - file
# Second - line to append
append_new () { grep -qxF "$2" "$1" || echo "$2" >> "$1" ; }

exit_on_fail () {
    exit_code=$?
    exit_message="$1"
    ignored_codes=$2

    if [ $exit_code -ne 0 ] && [[ ! ${ignored_codes[*]} =~ $exit_code ]]; then
        error "$exit_message"
        warn "Exiting the script"
        exit $exit_code
    fi
}

