local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require("beautiful")

local system_widget_resources = {
    {
        name = "networking",
        normal_image = beautiful.hogbar.networking_normal,
        top = 11,
        bottom = 11,
    },
    {
        name = "notifications",
        normal_image = beautiful.hogbar.notifications_normal,
        top = 11,
        bottom = 11,
    }
}

local function setup_system_buttons(args)
    local resources = args.resources
    local s = args.screen

    local all_buttons = { }

    for _, tab in pairs(resources) do
        local normal_image = tab.normal_image
        local hover_image = tab.hover_image or normal_image

        local system_widget = wibox.widget({
            screen = s,
            widget = wibox.container.background,
            bg = "#FF800000",
            {
                widget = wibox.container.place,
                {
                    widget = wibox.container.margin,
                    top = tab.top,
                    bottom = tab.bottom,
                    forced_width = 18,
                    {
                        id = "button_img",
                        widget = wibox.widget.imagebox,
                        image = normal_image
                    }
                }
            }
        })

        local button_image = system_widget:get_children_by_id("button_image")[1]

        system_widget:connect_signal("mouse:enter", function()
                                         button_image.image = hover_image
                                    end)

        system_widget:connect_signal("mouse:leave", function()
                                         button_image.image = hover_image
                                    end)

        table.insert(all_buttons, #all_buttons + 1, system_widget)
    end

    return all_buttons
end

local function make_system_buttons(s)
    local mylayoutbox = wibox.widget({
            widget = wibox.container.margin,
            top = 2,
            bottom = 2,
            {
                layout = wibox.layout.fixed.horizontal,
                awful.widget.layoutbox(s),
            }
    })

    mylayoutbox:buttons(gears.table.join(
                            awful.button({  }, 1, function () awful.layout.inc(1) end),
                            awful.button({  }, 3, function () awful.layout.inc(-1) end),
                            awful.button({  }, 4, function () awful.layout.inc(1) end),
                            awful.button({  }, 5, function () awful.layout.inc(-1) end)))

    local final_system_buttons = ({
            [1] = mylayoutbox,
            spacing = 14,
            widget = wibox.container.background,
            layout = wibox.layout.fixed.horizontal
    })

    for _, v in pairs(setup_system_buttons({screen = s, resources = system_widget_resources})) do
        table.insert(final_system_buttons, #final_system_buttons + 1, v)
    end

    return wibox.widget(final_system_buttons)
end

local function make_right_widget(s)
    local tray = wibox.widget.systray()
    tray.set_screen(s)
    local setup_widget = wibox.widget({
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.margin,
            right = 0,
            {
                widget = wibox.widget.background,
                bg = "#00FF00",
                {
                    widget = wibox.layout.fixed.horizontal,
                    tray
                }
            }
        },
        make_system_buttons(s)
    })

    return setup_widget
end

return make_right_widget

