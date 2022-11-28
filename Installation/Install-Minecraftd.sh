#!/bin/bash

source common.sh
service_name=minecraftd.service

# Copying minecraft.service to systemd
info "Installing minecraft service"
cp --preserve=mode "$service_name" /etc/systemd/system/

# Enabling service 
systemctl daemon-reload 
systemctl enable --now $service_name
info "Enabled $service_name"
