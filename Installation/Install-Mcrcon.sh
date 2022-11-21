#!/bin/bash 

source common.sh

#Installing mcrcon  
rpm -qa | grep -q mcrcon
exit_code=$?
if [ $exit_code == 0 ]; then 
	info "mcrcon already installed" 
else 	
	yum install -y mcrcon
	exit_on_fail "Failed to install mcrcon" 
	info "Installed mcrcon"
fi 
