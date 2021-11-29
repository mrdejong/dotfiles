local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi

local weather = require("modules.sidebar.weather")
local cpu = require("modules.sidebar.cpu")
local calendar = require("modules.sidebar.calendar")
local sensors = require("modules.sidebar.sensors")

local helpers = require("modules.sidebar.helpers")

local utils = require("utils")

local popup = wibox({
        y       = dpi(10),
        ontop   = true,
        opacity = 1.0,
        bg      = beautiful.bg_normal .. "B3",
        shape   = utils.rrect(6),
        width   = dpi(300),
        type    = "dock",
        visible = false,
})

local separator = wibox.widget {
    forced_height = dpi(1),
    color = {
        type = 'linear',
        from = {0, 0},
        to = {dpi(300), 0},
        stops = {
            { 0.05, beautiful.colors.darkblue .. '00' },
            { 0.5, beautiful.colors.darkblue },
            { 0.95, beautiful.colors.darkblue .. '00' }
        }
    },
    widget = wibox.widget.separator()
}

popup:setup {
    {
        helpers.decorator(weather.widget, dpi(10)),
        layout = wibox.layout.fixed.vertical
    },
    {
        helpers.decorator(cpu.widget),
        helpers.decorator(sensors.widget),

        separator,

        spacing = dpi(4),
        layout = wibox.layout.fixed.vertical
    },
    {
        separator,
        spacing = dpi(4),

        helpers.decorator(calendar.widget, nil, dpi(35)),
        layout = wibox.layout.fixed.vertical
    },
    layout = wibox.layout.align.vertical
}

local function timer_callback()
    cpu.update()
    sensors.update()
end

local timer = gears.timer({
        timeout = 1,
        callback = timer_callback
})

local sidebar = {}

function sidebar.toggle()
    if not timer.started then
        timer_callback()

        weather.update()
        calendar.update()

        local fscreen = awful.screen.focused()
        local geo = fscreen.geometry

        popup.screen = fscreen
        popup.height = geo.height - dpi(40)
        popup.y = geo.y + dpi(20)
        popup.x = geo.x + 10 -- geo.x + geo.width - dpi(610)
        popup.visible = true
        timer:start()
    else
        timer:stop()
        popup.visible = false
        collectgarbage('collect')
    end
end

popup:buttons(gears.table.join(awful.button({}, 3, function()
                                       sidebar.toggle()
end)))

return sidebar
