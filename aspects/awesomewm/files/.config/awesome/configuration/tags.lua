local awful     = require('awful')
local beautiful = require('beautiful')

local tags = {
    {
        {
            text = 'web',
            icon = '爵'
        }, -- 1
        {
            text = 'Editor',
            icon = ''
        }, -- 2
        {
            text = 'Terminal',
            icon = ''
        }, -- 3
        {
            text = 'Files',
            icon = ''
        }, -- 4
        {
            text = 'Discord',
            icon = 'ﭮ'
        }, -- 5
        {
            text = 'Minecraft',
            icon = ''
        }, -- 6
        {
            text = 'misc',
        } -- 7
    }, -- Screen 1
    {
        {
            trext = 'Spotify',
            icon = '阮'
        }, -- 1
        {
            text = 'YouTube',
            icon = ''
        } -- 2
    } -- Screen 2
}

awful.layout.layouts = {awful.layout.suit.tile, awful.layout.suit.max, awful.layout.suit.floating}

awful.screen.connect_for_each_screen(function(s)
    for i, tag in pairs(tags[s.index]) do
        awful.tag.add(tag.text, {
            -- icon = tag.icon or nil,
            -- icon_only = false,
            layout = awful.layout.suit.tile,
            gap = beautiful.gaps,
            screen = s,
            -- defaultApp = tag.defaultApp,
            selected =  i == 1,
            font_icon = tag.icon or nil
        })
    end
end)

_G.tags = tags
