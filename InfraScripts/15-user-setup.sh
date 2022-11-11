#!/bin/bash

# Configuration
users=(darek fafa wojtek minecraft)
sudoers=(darek fafa wojtek)

# Get functions: info, warn, error, exit_on_fail, append_new
source common.sh

info "Beginning user creation"
# Create all the users
for user in ${users[@]}; do
    adduser -m $user
    exit_on_fail "User creation failed!" "(9)"
done
info "User creation completed"

# Create a drop-in in sudoers.d
info "Creating a sudoers drop-in file"
sudoers_file="/etc/sudoers.d/50-configured-sudoers"
touch "$sudoers_file"
chmod 440 "$sudoers_file"
exit_on_fail "Can't create a drop-in $sudoers_file with proper permissions"

# Configure sudoers
for user in ${sudoers[@]}; do
    line="$user ALL=(ALL) NOPASSWD:ALL"
    append_new "$sudoers_file" "$line"
    exit_on_fail "Can't append the user $user to $sudoers_file"
done

# Setup SSH keys
