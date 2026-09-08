fx_version "cerulean"
game "gta5"
lua54 "yes"

name "cu_multijob"
author "cu"
version "1.0.0"

ui_page "web/dist/index.html"

shared_scripts {
    "@ox_lib/init.lua",
    "shared/config.lua",
    "bridge/bridge.lua",
}

client_scripts {
    "client/**/*.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/**/*.lua",
}

files {
    "web/dist/index.html",
    "web/dist/**/*",
    "bridge/framework/client/**",
}

escrow_ignore {
    "**/*",
}
dependency '/assetpacks'