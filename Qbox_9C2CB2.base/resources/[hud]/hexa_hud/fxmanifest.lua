fx_version 'cerulean'
game 'gta5'

author 'Services RP'
description 'HUD moderne compatible ESX et QBCore'
version '1.1.1'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/app.js'
}

shared_script 'config.lua'
client_scripts {
    'client.lua',
    'hidehud.lua'
}
server_script 'server.lua'

escrow_ignore {
  'config.lua',
  'README.md'
}

lua54 'yes'

dependency '/assetpacks'