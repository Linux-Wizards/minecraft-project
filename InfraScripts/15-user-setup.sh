#!/bin/bash

# Configuration
users=(darek fafa wojtek minecraft)
sudoers=(darek fafa wojtek)

# Get functions: info, warn, error, exit_on_fail, append_new
source common.sh

# Check if running as root
source check-root.sh

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
info "Appending sudoers to the drop-in file"
for user in ${sudoers[@]}; do
    line="$user ALL=(ALL) NOPASSWD:ALL"
    append_new "$sudoers_file" "$line"
    exit_on_fail "Can't append the user $user to $sudoers_file"
done

# Setup SSH keys
info "Configuring SSH authorized keys for the users"
for user in ${users[@]}; do
    new_key="keys/${user}"
    if [ -f "$new_key" ]; then
        ssh_dir="$(home_dir $user)/.ssh"
        authorized_keys="${ssh_dir}/authorized_keys"

        install -d -o "$user" -g "$(user_group $user)" -m 700 "$ssh_dir"
        exit_on_fail "Can't create the .ssh directory ($ssh_dir) for $user"

        # Do not overwrite existing authorized_keys
        if [ ! -f "authorized_keys" ]; then
            install -o "$user" -g "$(user_group $user)" -m 600 "$new_key" "$authorized_keys"
            exit_on_fail "Can't install the authorized_keys file ($authorized_keys) for $user"
        else
            append_new $authorized_keys "$(<$new_keys)"
            exit_on_fail "Can't append a new key to authorized_keys file ($authorized_keys) for $user"
        fi
    fi
done

info "SSH key configuration completed"
