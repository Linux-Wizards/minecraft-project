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

# Variables to preserve

variables_preserved="mc_version,paper_build,username,install_dir,online_mode,rcon_password,download_location"

# Getting useful functions related
source common.sh

sudo --preserve-env="$variables_preserved" --user="$username"

