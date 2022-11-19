#!/bin/bash 

# Version configuration
mc_version="1.19.2" 
paper_build="271"

# Server configuration
username="minecraft"
install_dir="server"
online_mode="false"
rcon_password="linuxwizards"

# Server jar address 
download_location="https://api.papermc.io/v2/projects/paper/versions/${mc_version}/builds/${paper_build}/downloads/paper-${mc_version}-${paper_build}.jar"

# Getting useful functions
source common.sh

# Check if user is root 
source check-root.sh

mkdir -p -m 777 /tmp/minecraft-project/
cp -a $(readlink -f common.sh) /tmp/minecraft-project/
cp -a Install-Minecraft.sh /tmp/minecraft-project/

info "Beginnig server installation "

./Install-Java.sh

sudo --login --user="$username" install_dir="$install_dir" online_mode="$online_mode" rcon_password="$rcon_password" download_location="$download_location" /tmp/minecraft-project/Install-Minecraft.sh
exit_on_fail "Failed to start installation"

info "Installation success"
