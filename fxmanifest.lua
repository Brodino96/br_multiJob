fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Brodino"
description "A simple multi job script"
version "1.0"

shared_scripts { "@ox_lib/init.lua", "config.lua", "locales/*" }
server_scripts { "@oxmysql/lib/MySQL.lua", "server/*", }
client_scripts { "client/*", }

exports { "getJobs" }