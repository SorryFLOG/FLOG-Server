fx_version 'cerulean'
author 'Marttins | MT Scripts'
description 'Best workhops/mechanic script for FiveM'
game 'gta5'
lua54 'yes'

version '2.0.9'

shared_scripts {
    '@ox_lib/init.lua',
    'configs/*.lua',
    'workshops/*.lua'
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

ui_page 'web/build/index.html'

files {
    'locales/*.json',
    'web/build/**/*',
    "meta/carcols_gen9.meta",
    "meta/carmodcols_gen9.meta",
    "stream/vehicle_paint_ramps.ytd"
}

data_file "CARCOLS_GEN9_FILE" "meta/carcols_gen9.meta"
data_file "CARMODCOLS_GEN9_FILE" "meta/carmodcols_gen9.meta"

escrow_ignore {
    'workshops/*.lua',
    'configs/*.lua',
    -- 'client/*.lua',
    -- 'server/*.lua',
    'server/functions.lua',
    'server/items.lua',
}
dependency '/assetpacks'