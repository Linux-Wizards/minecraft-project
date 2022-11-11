#!/bin/bash

# Configuration
db_name="mc_db"
db_user="mc_user"
db_pass="linuxwizards"
db_root_pass="linuxwizards"

# Get functions: info, error, exit_on_fail
source common.sh

basic_single_escape () {
    echo "$1" | sed 's/\(['"'"'\]\)/\\\1/g'
}

do_query () {
    mariadb -e "$1"
    exit_on_fail "Securing MariaDB failed"
}

info "Starting MariaDB installation"

yum -y install mariadb mariadb-server mariadb-backup
exit_on_fail "MariaDB installation possibly failed"

systemctl enable --now mariadb.service
exit_on_fail "MariaDB couldn't be started and/or enabled"

#
# Secure the database
#
esc_pass=`basic_single_escape "$db_root_pass"`
do_query "UPDATE mysql.global_priv SET priv=json_set(priv, '$.plugin', 'mysql_native_password', '$.authentication_string', PASSWORD('$esc_pass')) WHERE User='root';"

do_query "DELETE FROM mysql.global_priv WHERE User='';"

do_query "DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

do_query "DROP DATABASE IF EXISTS test;"

do_query "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"

do_query "FLUSH PRIVILEGES;"

#
# Configure the database for Minecraft
#

