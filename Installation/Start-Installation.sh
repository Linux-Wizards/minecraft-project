#!/bin/bash 

# Server configuration
username="minecraft"

# Getting useful functions
source common.sh

# Check if user is root 
source check-root.sh

mkdir -p -m 777 /tmp/minecraft-project/
cp -a $(readlink -f common.sh) /tmp/minecraft-project/
cp -a Install-Minecraft.sh /tmp/minecraft-project/

info "Beginnig server installation "

./Install-Java.sh
sudo --login --user="$username" /tmp/minecraft-project/Install-Minecraft.sh
exit_on_fail "Failed to start minecraft installation"

info "Installation success"
