local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi

local weather_text = wibox.widget {
    valign        = 'center',
    text          = '0°C',
    forced_height = dpi(30),
    forced_width  = dpi(204),
    wrap          = 'word',
    font          = beautiful.font_sized(16),
    widget        = wibox.widget.textbox
}

local weather_description = wibox.widget {
    -- align         = 'center',
    valign        = 'center',
    text          = 'Wait for update',
    forced_height = dpi(30),
    forced_width  = dpi(204),
    wrap          = 'word',
    font          = beautiful.font_sized(16),
    widget        = wibox.widget.textbox
}

local api_key = 'c66a0cfb21bbac284432aa73518ca1e2'

local function weather_update()
    local city_id = "Schagen,NL"
    local command = "/home/alexander/weather.sh"

    awful.spawn.easy_async(command, function(stdout)
        local icon_code, temp, description = stdout:match("(%w+);([-%d]+);([ %w]+)")
        local icon = ''

        icon_code = icon_code or '0'
        temp = temp or '0'
        description = description or 'Weather unknown'

        if icon_code == '01d' then
            icon = ''
        elseif icon_code == '01n' then
            icon = ''
        elseif icon_code == '02d' then
            icon = ''
        elseif icon_code == '02n' then
            icon = ''
        elseif icon_code:find('02') or icon_code:find('03') or icon_code:find('04') then
            icon = ''
        elseif icon_code:find('09') then
            icon = ''
        elseif icon_code == '10d' then
            icon = ''
        elseif icon_code == '10n' then
            icon = ''
        elseif icon_code:find('11') then
            icon = ''
        elseif icon_code:find('13') then
            icon = ''
        elseif icon_code:find('50') then
            icon = ''
        else
            icon = '×'
        end

        weather_text:set_text(icon .. " " .. temp .. "°C")
        weather_description:set_text(description)
    end)
end

local weather_widget = wibox.widget {
    weather_text,
    weather_description,
    layout = wibox.layout.fixed.vertical
}


return {
    widget = weather_widget,
    update = weather_update
}
