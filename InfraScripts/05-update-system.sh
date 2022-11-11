#!/bin/bash

# Get functions: info, error, exit_on_fail
source common.sh

info "Beginning an upgrade"

yum -y upgrade --refresh
exit_on_fail "System upgrade possibly failed"

info "Rebooting"
reboot

