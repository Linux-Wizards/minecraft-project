#!/bin/bash 

# Getting useful functions
source common.sh

java_repo_key_url="https://yum.corretto.aws/corretto.key"
java_version="java-17"
java_repo_dir="/etc/yum.repos.d/corretto.repo"
java_repo_url="https://yum.corretto.aws/corretto.repo"

rpm -qa | grep "$java_version"

if [ "$exit_code" -ne 0 ]; then
warn "No java 17 available, download required" 

# Java installation 
rpm --import "$java_repo_key_url"
curl -L "$java_repo_dir" "$java_repo_url"
yum install -y -q "$java_version"

fi

info "Java 17 installed "

