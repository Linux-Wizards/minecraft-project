#!/bin/bash

info () { echo -e "\e[32m[INFO]\e[0m ${1}" ; }
warn () { echo -e "\e[33m[WARN]\e[0m ${1}" ; }
error () { echo -e "\e[31m[ERROR]\e[0m ${1}" ; }
home_dir () { getent passwd "$1" | cut -d: -f6 ; } # https://superuser.com/questions/484277/get-home-directory-by-username
user_group () { id -G $1 ; }

# Check if running as root
if [ $(id -u) -ne 0 ]; then # https://stackoverflow.com/questions/18215973/how-to-check-if-running-as-root-in-a-bash-script
    error "Please run this script as root!"
    exit 1
fi

# First argument - file
# Second - line to append
append_new () { grep -qxF "$2" "$1" || echo "$2" >> "$1" ; } # https://stackoverflow.com/questions/3557037/appending-a-line-to-a-file-only-if-it-does-not-already-exist

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

