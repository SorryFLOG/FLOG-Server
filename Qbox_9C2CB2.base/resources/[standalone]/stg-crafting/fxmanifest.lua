fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'STG Scripts'
description 'stgscripts.com | discord.gg/stg'
version '1.1.0'

dependencies {
    'ox_lib',
    'stg_lib', -- https://github.com/stgscripts/stg_lib/releases/latest/download/stg_lib.zip
    'oxmysql',
}

shared_scripts {
    '@ox_lib/init.lua',
    'locales/*.lua',
    'shared/config.lua',
    'shared/recipes.lua',
}

client_scripts {
    'client/editable/target.lua',
    'client/main.lua',
    'client/craft.lua',
    'client/web.lua',
    'client/creator.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'version.lua',
    'server/main.lua',
    'server/craft.lua',
    'server/creator.lua',
}

ui_page 'web/index.html'

files {
    'web/**/**.**',
    'shared/themes/*.css',
}

escrow_ignore {
    'locales/*.lua',
    'shared/config.lua',
    'shared/recipes.lua',
    'client/editable/target.lua'
}
dependency '/assetpacks'