fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Crazy Eyes Studio'
description 'Advanced AI Medic Script - QBCore & Standalone Compatible'
version '1.5.0'

shared_script 'config.lua'

client_scripts {
    'client/client.lua',
    'client/utils_client.lua'
}

server_scripts {
    'server/server.lua',
    'server/utils_server.lua'
}
