#!/bin/bash

# What a pity - disable SELinux (at least for now)

# Get functions: info, error, exit_on_fail
source common.sh

# Check if running as root
source check-root.sh

warn "Setting SELinux to Permissive temporarily"
setenforce Permissive

warn "Making SELinux Permissive permanent"
sed -i "s/SELINUX=enforcing.*/SELINUX=permissive/g" /etc/selinux/config
exit_on_fail "Can't permanently disable SELinux"

if [ ! $(getenforce) = "Enforcing" ]; then
    info "SELinux successfully disabled"
else
    error "Couldn't disable SELinux"
    warn  "The Minecraft service won't run with SELinux enabled"
    exit 1
fi
