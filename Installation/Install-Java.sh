#!/bin/bash 

# Getting useful functions
source common.sh

java_repo_key_url="https://yum.corretto.aws/corretto.key"
java_version="java-17"
java_repo_dir="/etc/yum.repos.d/corretto.repo"
java_repo_url="https://yum.corretto.aws/corretto.repo"

rpm -qa | grep "$java_version"
exit_code=$?

if [ "$exit_code" -ne 0 ]; then
        warn "No java 17 available, download required"

        # Java installation 
        rpm --import "$java_repo_key_url"
        info "Imported Java repo key"
        curl -L -o "$java_repo_dir" "$java_repo_url"
        info "Added Java repository to yum"
        yum install -y "$java_version-amazon-corretto*"
        info "Completed installation succesfully"
else
        info "$java_version already installed"
fi
