local awful      = require('awful')
local beautiful  = require('beautiful')
local separators = require('widget.material.separator')
local markup     = require('widget.material.markup')
local wibox      = require('wibox')
local TagList    = require('widget.tag-list')
local gears      = require('gears')
local dpi        = beautiful.xresources.apply_dpi
local table      = awful.util.table or gears.table


local arrow = separators.arrow_left
local function create_arrow(mywidget, bgcolor, fgcolor)
    return (wibox.container.background(
        wibox.widget {
            arrow(fgcolor, bgcolor),
            mywidget,
            arrow(bgcolor, fgcolor),
            spacing = dpi(4),
            layout = wibox.layout.fixed.horizontal
        },
        bgcolor
    ))
end

local function create_icon(label, icon_color)
    return (wibox.widget {
        wibox.widget {
            text         = label,
            font         = beautiful.icon_font,
            widget       = wibox.widget.textbox,
            align        = 'center',
            forced_width = dpi(32)
        },
        fg      = icon_color,
        widget = wibox.container.background
    })
end

local top_bar = function (s, offset)
    local function update_txt_layoutbox(s1)
        local txt_l = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s1))] or ""
        s1.layoutbox:set_text(txt_l)
    end

    s.layoutbox = wibox.widget.textbox(beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s))])
    s.layoutbox.font = beautiful.icon_font
    awful.tag.attached_connect_signal(s, "property::selected", function () update_txt_layoutbox(s) end)
    awful.tag.attached_connect_signal(s, "property::layout", function () update_txt_layoutbox(s) end)
    s.layoutbox:buttons(table.join(
                            awful.button({}, 1, function () awful.layout.inc(1) end),
                            awful.button({}, 2, function () awful.layout.set(awful.layout.layouts[1]) end),
                            awful.button({}, 3, function () awful.layout.inc(-1) end),
                            awful.button({}, 4, function () awful.layout.inc(1) end),
                            awful.button({}, 5, function () awful.layout.inc(-1) end)
    ))

    local systray = wibox.widget.systray()
    systray.visible = false
    systray:set_horizontal(true)

    -- Widgets
    local clock_widget = require('widget.clock')
    local battery_widget = require('widget.battery')
    local memory_widget = require('widget.memory')
    local net = require('widget.net')
    local net_sent = net({
        settings = function()
            widget:set_markup(markup.font(beautiful.font, net_now.sent))
        end
    })
    local net_received = net({
        settings = function()
            widget:set_markup(markup.font(beautiful.font, net_now.received))
        end
    })

    local system_details = wibox.widget {
        systray,
        -- Internet
        wibox.widget{
            create_icon('', beautiful.accent.hue_200),
            net_received.widget,
            create_icon('', beautiful.accent.hue_300),
            net_sent.widget,
            spacing = dpi(4),
            layout = wibox.layout.fixed.horizontal
        },
        -- battery
        battery_widget,
        -- Memory
        wibox.widget{
            create_icon('', beautiful.accent.hue_500),
            memory_widget,
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(4)
        },
        wibox.widget{
            create_icon('', beautiful.accent.hue_400),
            clock_widget,
            -- Layout
            -- wibox.widget {
            --     wibox.widget{
            --         wibox.container.margin(s.layoutbox, dpi(4), dpi(4), dpi(0), dpi(0)),
            --         fg = beautiful.primary.hue_100,
            --         bg = beautiful.accent.hue_200,
            --         widget = wibox.container.background
            --     },
            --     forced_width = dpi(32),
            --     layout = wibox.layout.fixed.horizontal
            -- },
            layout = wibox.layout.fixed.horizontal
        },
        spacing = dpi(20),
        layout = wibox.layout.fixed.horizontal
    }

    local pwidth = s.geometry.width - 200

    local panel = wibox({
        ontop   = false,
        screen  = s,
        type    = 'dock',
        height  = dpi(32),
        width   = s.geometry.width - 200,
        x       = (s.geometry.x) + 100,
        y       = s.geometry.y,
        stretch = false,
        bg      = beautiful.primary.hue_100 .. '00',
        fg      = beautiful.fg_normal
    })

    panel:struts({
        top = panel.height - panel.y
    })

    panel:setup{
        layout = wibox.layout.align.horizontal,
        TagList(s),
        nil,
        system_details
    }

    return panel
end

return top_bar
