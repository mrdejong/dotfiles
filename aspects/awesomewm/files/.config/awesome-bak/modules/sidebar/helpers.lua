local wibox     = require("wibox")
local dpi       = require("beautiful.xresources").apply_dpi
local beautiful = require("beautiful")
local utils     = require("utils")

local function decorator(w, vmargin, hmargin, fg)
    return {
        {
            w,
            bg                 = beautiful.colors.red .. "00",
            fg                 = fg or beautiful.fg_normal,
            shape = utils.rrect(3),
            shape_border_color = beautiful.si_inner_border_color or beautiful.colors.darkGrey,
            shape_border_width = beautiful.si_inner_border_width or dpi(1),
            widget             = wibox.container.background
        },
        forced_width    = dpi(200),
        top             = vmargin or dpi(2),
        bottom          = vmargin or dpi(2),
        left            = hmargin or dpi(10),
        right           = hmargin or dpi(10),
        widget          = wibox.container.margin,
    }
end

local function icon_label(label, widget, label_size)
    label_size = label_size or 11
    return {
        {
            text            = label,
            font            = "Hack Nerd Font " .. label_size,
            align           = 'center',
            valign          = 'center',
            forced_width    = 30,
            forced_height   = 30,
            widget          = wibox.widget.textbox,
        },
        widget,
        layout = wibox.layout.align.horizontal,
    }
end

local function icon(icon, ...)
    local opts = {...}
    local label_size = opts.label_size or 11
    local width = opts.width or 30
    local height = opts.height or 30
    local font = opts.font or "Hack Nerd Font"
    return {
        {
            text            = icon,
            font            = font .. " " .. label_size,
            align           = 'center',
            valign          = 'center',
            forced_width    = width,
            forced_height   = height,
            widget          = wibox.widget.textbox,
        },
        layout = wibox.layout.align.horizontal,
    }
end

local function add_label(label, widget, label_size)
    label_size = label_size or 15
    return {
        {
            text            = label,
            font            = "Roboto " .. label_size,
            -- align           = 'center',
            valign          = 'center',
            forced_width    = dpi(20),
            forced_height   = dpi(32),
            widget          = wibox.widget.textbox,
        },
        widget,
        layout = wibox.layout.align.horizontal,
    }
end

return {
    icon = icon,
    add_label = add_label,
    decorator = decorator,
    icon_label = icon_label
}