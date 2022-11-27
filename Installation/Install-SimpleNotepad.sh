#!/bin/bash

source /tmp/minecraft-project/common.sh

# Server config
plugin_version="v0.1.1"
plugin_link="https://github.com/Linux-Wizards/minecraft-project/releases/download/$plugin_version/simplenotepad-1.0-SNAPSHOT.jar"
install_dir="server/plugins"

# DB config vars
db_name="mc_db"
db_user="mc_user"
db_pass="linuxwizards"
db_host="localhost"

# Creating plugin directory 
mkdir -p "$install_dir"
cd "$install_dir"

# Downloading SimpleNotepad plugin
info "Downloading SimpleNotepad"
curl -o SimpleNotepad.jar "$plugin_link"
mkdir SimpleNotepad
info "Download completed"

# DB config 
info "Configuring the plugin"
cat > SimpleNotepad/config.yml << EOL 
# Your database type
# MySQL is also compatible with MariaDB
# Databases supported: MySQL
db_type: mysql
# The address of your database (can be 'localhost')
db_host: "$db_host"
# The port that your database uses
db_port: 3306
# The database name you want to use (the database should already exist)
db_name: "$db_name"
# Do you want to use SSL when connecting to the database?
db_ssl: false
# The username used for connection to the database
db_user: "$db_user"
# The password used for connection to the database
db_password: "$db_pass"
# The table you want to use (will be created automatically if it doesn't exist)
# Please note that for ID generation, a second table with '_sequence' suffix may be created
table_name: simple_notepad
# How many concurrent connections can the plugin make?
db_connections: 10
# Do you want to automatically regenerate Hibernate's configuration when loading the plugin?
# Useful for debugging Hibernate
regenerate_hibernate_config: true
EOL
info "Plugin installed"
