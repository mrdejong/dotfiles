local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local apps = require('configuration.apps')
local dpi = require('beautiful').xresources.apply_dpi

local screens = {
    primary = 1,
    secondary = 2,
    all = -1
}

local tags = {
    {
        {
            text = 'web',
            icon = '爵'
        },
        {
            text = 'Editor',
            icon = ''
        },
        {
            text = 'Terminal',
            icon = ''
        },
        {
            text = 'Files',
            icon = ''
        },
        {
            text = 'Discord',
            icon = 'ﭮ'
        },
        {
            text = 'misc',
        }
    },
    {
        {
            trext = 'Spotify',
            icon = '阮'
        },
        {
            text = 'YouTube',
            icon = ''
        }
    }
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
            selected = i == 1,
            font_icon = tag.icon or nil
        })
    end
end)

_G.tags = tags
