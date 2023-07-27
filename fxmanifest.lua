fx_version 'cerulean'
games { 'gta5' }

author 'Discord: etzinho | https://discord.gg/KNNW93QD2P'
description 'Efeitos diferentes para suas drogas do servidor'
version '1.2.0'

ui_page 'html/ui.html'

client_scripts {
    '@vrp/lib/utils.lua',
    'config.lua',
    'client/*.lua',
}

server_scripts {
    '@vrp/lib/utils.lua',
    'config.lua',
    'server/*.lua',
}