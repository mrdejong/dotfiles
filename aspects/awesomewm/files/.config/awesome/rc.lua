-- Importing libraries
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")

local naughty = require("naughty")

local gfs = require("gears.filesystem")

local function dbug(msg)
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Debug",
                     message = "Hello world"
    })
end

local theme_path = string.format('%s/.config/awesome/themes/%s/theme.lua', os.getenv('HOME'), 'quiet')
beautiful.init(theme_path)

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     message = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         message = tostring(err) })
        in_error = false
    end)
end


require('keybindings')

require("bar")

require("ui")

require("extras")

-- require("corners")

local bling = require('bling')

local machi = require("layout-machi")

local revelation = require("awesome-revelation")
revelation.init()

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

awful.spawn.with_shell("~/.config/awesome/autostart.sh")
