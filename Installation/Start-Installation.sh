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

# Java installation
./Install-Java.sh

# Mcrcon installation
./Install-Mcrcon.sh 

# Minecraft installation
sudo --login --user="$username" /tmp/minecraft-project/Install-Minecraft.sh
exit_on_fail "Failed to start minecraft installation"

# Firewall config 
firewall-cmd -q --add-port=25565/tcp --permanent
exit_on_fail "Failed to configure firewall" 
firewall-cmd -q --reload
info "Firewall configured port 25565/tcp"

# Systemd copying 
./Install-Minecraftd.sh

info "Installation success"
