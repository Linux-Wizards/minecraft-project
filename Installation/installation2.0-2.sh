#!/bin/bash

source /tmp/minecraft-project/common.sh
echo "$username"
mkdir -p "$install_dir"  # Creating installation directory for server 
exit_on_fail "Failed to create directory"  
info "Created server directory ${PWD}/${install_dir}"

pushd "$install_dir" 


info "Starting download" 
curl -o paper.jar "$download_location"
exit_on_fail "Failed to download" 
info "Finished download"
