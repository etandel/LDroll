package = 'LDroll'
version = '0.1-1'
source = {
git@github.com:etandel/LDroll.git
   url = 'git://github.com/etandel/ldroll',
   tag = '0.1',
}
description = {
   summary = 'A dice rolling utility and library.',
   detailed = [[
    A utility and a library / language for rolling dice that features
    some processing over the rolls.
]],
   homepage = 'https://github.com/etandel/LDroll',
   license = 'GPL2',
   maintainer = 'Elias Tandel Barrionovo <elias.tandel@gmail.com>',
}
dependencies = {
   'lua >= 5.2',
   'lpeg >= 0.12',
}
build = {
    type = 'builtin',
    modules = {
        ['ldroll.ldroll'] = 'src/ldroll/ldroll.lua',
        ['ldroll.parser'] = 'src/ldroll/parser.lua',
        ['ldroll.init'] = 'src/ldroll/init.lua',
    },
    install = {
        bin = {
            ldroll = 'src/main.lua',
        },
    },
}
