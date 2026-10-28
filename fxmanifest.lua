fx_version 'cerulean'
game 'gta5'

name 'nova-pausemenu'
author 'Nova'
description 'Standalone ESC pause menu. Works with QBCore, ESX, or neither.'
version '1.1.0'

shared_scripts {
    'config.lua',
}

client_script 'client.lua'
server_script 'server.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
}

lua54 'yes'
