#!/bin/bash

java_package="jdk-19-headless"

# Get functions: info, error, exit_on_fail
source common.sh

# Check if running as root
source check-root.sh

info "Beginning Java installation"

yum -y install "$java_package"
exit_on_fail "Java installation possibly failed"

info "Finished installing Java"

