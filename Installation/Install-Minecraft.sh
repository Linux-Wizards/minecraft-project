#!/bin/bash

# Version configuration
mc_version="1.19.2"
paper_build="271"

# Server configuration
install_dir="server"
online_mode="false"
rcon_password="linuxwizards"

# Server jar address 
download_location="https://api.papermc.io/v2/projects/paper/versions/${mc_version}/builds/${paper_build}/downloads/paper-${mc_version}-${paper_build}.jar"

source /tmp/minecraft-project/common.sh
mkdir -p "$install_dir"  # Creating installation directory for server 
exit_on_fail "Failed to create directory"  
info "Created server directory ${PWD}/${install_dir}"

cd "$install_dir" 

info "Starting download" 
#curl -o paper.jar "$download_location"
#exit_on_fail "Failed to download" 
info "Finished download"

info "Accepting eula.txt" 
echo "eula=true" > eula.txt

# Configruing server properties
info "Configruing server properties"  
echo "online-mode=$online_mode" > server.properties 
echo "spawn-protection=0" >> server.properties
echo "rcon.password=$rcon_password" >> server.properties
echo "enable-rcon=true" >> server.properties
