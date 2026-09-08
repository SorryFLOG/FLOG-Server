fx_version 'adamant'
lua54 'yes'
game 'gta5'

author "STG Scripts"
description 'stgscripts.com | discord.gg/stg'
version '1.0.7'

shared_scripts { 
	'config.lua',
    '@ox_lib/init.lua',
}

client_script {
    "client/*.lua",
}

server_script {
    "server/utils/*.lua",
    "server/exports.lua",
    "version.lua"
}