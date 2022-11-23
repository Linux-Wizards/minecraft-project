#!/bin/bash 

source common.sh

#Installing mcrcon  
which mcrcon &>/dev/null 
exit_code=$?
if [ $exit_code == 0 ]; then 
	info "mcrcon already installed" 
else 
	cd /tmp/
	git clone https://github.com/Tiiffi/mcrcon.git
	cd mcrcon && make && make install 	
	ln -s /usr/local/bin/mcrcon /bin/mcrcon
	exit_on_fail "Failed to install mcrcon" 
	info "Installed mcrcon"
fi 
