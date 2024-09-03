fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Brodino"
version "Tua nonna"

shared_scripts { "@ox_lib/init.lua", "config.lua", }
server_scripts { "@oxmysql/lib/MySQL.lua", "server/*", }
client_scripts { "client/*", }

exports {
   "getJobs"
}