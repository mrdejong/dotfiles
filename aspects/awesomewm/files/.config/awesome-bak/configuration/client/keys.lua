local awful = require('awful')
require('awful.autofocus')
local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey

local function toggle_fullscreen(c)
    c.fullscreen = not c.fullscreen
    c:raise()
end

local clientKeys = awful.util.table.join(
    awful.key({modkey}, 'f', toggle_fullscreen, {
        description = 'toggle fullscreen',
        group = 'client'
    }),
    awful.key({modkey}, 'q', function(c) c:kill() end, {
        description = 'close',
        group = 'client'
    }),
    awful.key({modkey, 'Shift'}, 'f', function(c)
        c.sticky = not c.sticky
        c.ontop = not c.ontop
        c:raise()
    end, {
        description = 'convert to sticky window',
        group = 'client'
    }),
    awful.key({modkey}, 'c', function(c)
        c:kill()
    end, {
        description = 'close',
        group = 'client'
    }),
    awful.key({ modkey }, "o", function (c) c:move_to_screen() end, {
        description = "move to screen",
        group = "client"
    })
)


return clientKeys
