local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi

local helpers   = require("modules.sidebar.helpers")

local function new_sensors_text_widget(init_text)
    return wibox.widget {
        -- align         = 'center',
        text          = init_text,
        font          = beautiful.font,
        widget        = wibox.widget.textbox,
        forced_height = dpi(24)
    }
end

local cpu_widget = new_sensors_text_widget("CPU temp: +..°C")
local gpu_widget = new_sensors_text_widget("GPU temp: +..°C")

local function cpu_update()
    local command = [[sensors coretemp-isa-0000 -u]]

    awful.spawn.easy_async(command, function(stdout)
        local cpu = stdout:match(": (%d+).0")
        cpu_widget:set_text("CPU temp: +" .. cpu .. "°C")
    end)
end

local function gpu_update()
    local command = [[nvidia-settings -q gpucoretemp -t]]

    awful.spawn.easy_async(command, function(stdout)
        local gpu = stdout:match("(%d+)")
        if gpu then
            gpu_widget:set_text("GPU temp: +" .. gpu .. "°C")
        end
    end)
end

local function update()
    cpu_update()
    gpu_update()
end

return {
    widget = helpers.add_label(" ", {
        cpu_widget,
        gpu_widget,
        layout = wibox.layout.fixed.vertical
    }, 20),
    update = update
}
