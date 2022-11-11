#!/bin/bash

# Configuration
db_name="mc_db"
db_user="mc_user"
db_pass="linuxwizards"

# Get functions: info, error, exit_on_fail
source common.sh

info "Starting MariaDB installation"

yum -y install mariadb mariadb-server mariadb-backup
exit_on_fail "MariaDB installation possibly failed"

systemctl enable --now mariadb.service
exit_on_fail "MariaDB couldn't be started and/or enabled"

