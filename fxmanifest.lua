fx_version "adamant"
game "gta5"
lua54 'yes'

name         'azakit_moneywash'
version      '1.2.0'
author 'Azakit'
description 'Moneywash with tickets, licenses, tax levels, transport'

client_scripts {
	"locales/*",
	'config.lua',
	'client/*',
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"locales/*",
	'config.lua',
    'server/*'
}

shared_scripts {
    '@ox_lib/init.lua',
	'@es_extended/imports.lua',
    --'@qb-core/shared/items.lua', 
}

dependencies {
    'es_extended',
    'mysql-async',
    --'qb-core'
}

