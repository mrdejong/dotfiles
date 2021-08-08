require('awful.autofocus')
local gears     = require('gears')
local awful     = require('awful')
local naughty   = require('naughty')
local beautiful = require('beautiful')

require('module.notifications')

beautiful.init(require('theme'))

require('layout')

require('configuration.client')
require('configuration.tags')
_G.root.keys(require('configuration.keys.global'))

local function manage_client(c)
    if not _G.awesome.startup then
        awful.client.setslave(c)
    end

    if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end

_G.client.connect_signal('manage', manage_client)

-- Move cursor to focused window
function Move_mouse_onto_focused_client()
    local c = _G.client.focus
    gears.timer({
        timeout = 0.1,
        autostart = true,
        single_shot = true,
        callback = function()
            if _G.mouse.object_under_pointer() ~= c then
                local geometry = c:geometry()
                local x = geometry.x + geometry.width / 2
                local y = geometry.y + geometry.height / 2
                _G.mouse.coords({
                    x = x,
                    y = y
                }, true)
            end
        end
    })
end

if beautiful.cursor_warp then
    _G.client.connect_signal("focus", Move_mouse_onto_focused_client)
    _G.client.connect_signal("swapped", Move_mouse_onto_focused_client)
end

-- Enable sloppy focus, so that focus follows mouse.
_G.client.connect_signal('mouse::enter', function(c)
    c:emit_signal('request::activate', 'mouse_enter', {
        raise = true
    })
end)

-- Make the focused window have a glowing border
_G.client.connect_signal('focus', function(c)
    c.border_color = beautiful.border_focus
end)
_G.client.connect_signal('unfocus', function(c)
    c.border_color = beautiful.border_normal
end)

awful.spawn.with_shell("~/.config/awesome/autostart.sh")
