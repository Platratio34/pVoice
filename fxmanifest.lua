fx_version 'cerulean'
games { 'gta5' }

author 'Peter Crall <pcrall04@gmail.com>'
description 'Peter-Voice'
version '0.1.0-Dev'

client_scripts {
    'client/*.lua',
    'cl_*.lua'
}

server_scripts {
    'server/*.lua',
    'sv_*.lua',
    'config/*/*.lua'
}

shared_scripts {
    'shared/*.lua',
    'sh_*.lua'
}