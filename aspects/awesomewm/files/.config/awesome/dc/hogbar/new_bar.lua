local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local menubar = require('menubar')
local beautiful = require('beautiful')
local utils = require('utils')

local function d(data, t)
    n = require("naughty")
    n.notify({preset=n.config.presets.normal, title="debug", text=gears.debug.dump_return(data, t)})
end

local make_left_widget = require('dc.hogbar.left_widget')

awful.layout.layouts = {
    awful.layout.suit.tile
}

menubar.utils.terminal = "alacritty"

local time_text = wibox.widget {
    font = beautiful.font,
    format = "%a %b %d, %H:%M ",
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textclock,
}


local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                    awful.button({ }, 1, function(c)
                            if c == client.focus then
                                c.minimized = true
                            else
                                c:emit_signal(
                                    "request::activate",
                                    "tasklist",
                                    {raise = true}
                                )
                            end
                    end),
                    awful.button({ }, 3, function()
                            awful.menu.client_list({ theme = {width = 250 } })
                    end),
                    awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
                    awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
                )

local function make_hogbar(args)
    local s = args.screen
    local left_widget = args.left_widget

    s.mypromptbox = awful.widget.prompt()

    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- s.mytasklist = awful.widget.tasklist {
    --     screen = s,
    --     filter = awful.widget.tasklist.filter.currenttags,
    --     buttons = tasklist_buttons
    -- }

    s.systray = wibox.widget.systray()
    s.systray.visible = true

    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        shape = utils.rrect(5),
        width = s.geometry.width - 20,
        height = 32,
        ontop = false,
        bg = "#D8DEE980",
    })

    s.spacing = awful.wibar({
            type = 'utility',
            position = "top",
            screen = s,
            width = s.geometry.width,
            height = 10,
            bg = "#FF000000"
    })

    s.mywibox.x = s.geometry.x + 10
    s.mywibox.y = 10

    s.spacing.x = s.geometry.x
    s.spacing.y = 42

    s.mywibox:setup({
        widget = wibox.container.margin,
        layout = wibox.layout.manual,
        {
            point = { x = 5, y = 0 },
            forced_width = 300,
            forced_height = 32,
            layout = wibox.layout.fixed.horizontal,
            {
                widget = wibox.container.margin,
                top = 5,
                bottom = 5,
                left_widget
            }
        },
        {
            point = { x = (s.geometry.width - 20) - 140, y = 0 },
            forced_width = 140,
            forced_height = 32,
            layout = wibox.layout.fixed.horizontal,
            {
                widget = wibox.container.margin,
                top = 5,
                bottom = 5,
                {
                    widget = wibox.container.background,
                    shape = utils.rrect(3),
                    bg = '#1a1823'
                }
            }
        }
        -- {
        --     point = { x = (s.geometry.width - 20) - 140, y= 0 },
        --     forced_width = 140,
        --     forced_height = 32,
        --     -- bg = "#5D80AE80",
        --     widget = wibox.container.background,
        --     {
        --         layout = wibox.layout.fixed.horizontal,
        --         {
        --             widget = wibox.container.margin,
        --             top = 5,
        --             left = 13,
        --             bottom = 5,
        --             time_text
        --         }
        --     }
        -- }
    })
    s.spacing:setup({
        widget = wibox.container.margin,
        layout = wibox.layout.manual,
        {
            forced_width = s.geometry.width,
            forced_height = 10,
            layout = wibox.layout.fixed.horizontal
        }
    })
end


awful.screen.connect_for_each_screen(function(s)
    local names = { '1', '2', '3', '4', '5', '6', '7', '8', '9' }
    awful.tag(names, s, awful.layout.layouts[1])

    make_hogbar({
            screen = s,
            left_widget = make_left_widget({ screen = s })
    })
end)
