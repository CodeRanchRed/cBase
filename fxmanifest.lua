fx_version "cerulean"
game "rdr3"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'CodeRanch'
description 'cBase'
lua54 'yes'

shared_scripts {
    'shared/rpc.lua'
}

client_scripts {
    'config.lua',
    'client/main.lua',
    'client/functions.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/versionchecker.lua',
    'server/discordLog.lua',
    'server/functions.lua',
    'server/main.lua',
}

exports {
    'RegisterMethod',
    'CallRemoteMethod',
    'GetBase',
    'GetLangPreference'
}

server_exports {
    'RegisterMethod',
    'CallRemoteMethod',
    'SendLog'
}

version '1.0.3'
