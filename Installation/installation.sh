#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#Checking for java environment
if [[ $(rpm -qa | grep java) == java-17* ]]; then 
	echo "Java 17 already installed."
else 
	echo "No java environment installed, proceeding to installation."
	rpm --import https://yum.corretto.aws/corretto.key 
	curl -L /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
	yum -y install java-17-amazon-corretto-devel
fi 

#Checking for tmux and installing 
if [[ $(rpm -qa | grep tmux)  ]]; then
        echo "Tmux installed"
else 
	echo "Tmux installation" 
	yum install -y tmux
fi

#Creating user minecraft, directories and compiling mcrcon tool.
	useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft
	su - minecraft
	mkdir -pv ~/{backup,tools,server}
	git clone https://github.com/Tiiffi/mcrcon.git ~/tools
	gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

#Download and install the .jar file for minecraft host. 
	wget https://launcher.mojang.com/v1/objects/ed76d597a44c5266be2a7fcd77a8270f1f0bc118/server.jar -P ~/server
	java -Xms2G -Xmx2G -jar ~/server/server.jar nogui
	sed -i 's/eula=not-true/eula=true/g' ~/server/eula.txt 
	sed -i 's/enable-rcon=false/enable-rcon=true/g' ~/server/server.properties
	sed -i 's/rcon.port=*/rcon.port=25575' ~/server/server.properties


#Build Systemd Unit File 

