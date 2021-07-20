
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local dpi       = require("beautiful.xresources").apply_dpi
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local helpers = require("modules.sidebar.helpers")
require("awful.hotkeys_popup.keys")

-- Widget and layout library
local wibox = require("wibox")

-- Click to change to workspace
local taglist_buttons = gears.table.join(awful.button({}, 1, function(t) t:view_only() end))

local tasklist_buttons = gears.table.join(
    awful.button({}, 1,
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", {raise = true})
            end
        end),
    awful.button({}, 3,
        function()
            awful.menu.client_list({theme = {width = 250}})
        end)
)

awful.screen.connect_for_each_screen(function(s)
    awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.suit.tile)

    s.layoutbox = awful.widget.layoutbox(s)

    s.layoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end)
    ))

    s.taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    }

    s.tasklist =
        awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
            layout = {
                spacing = 0,
                spacing_widget = {
                    widget = wibox.container.background
                },
                layout = wibox.layout.fixed.horizontal
            },
            widget_template = {
                {
                    {
                        nil,
                        awful.widget.clienticon,
                        nil,
                        layout = wibox.layout.fixed.horizontal,
                    },
                    top = 5,
                    bottom = 5,
                    left = 10,
                    right = 10,
                    widget = wibox.container.margin
                },
                id = "background_role",
                widget = wibox.container.background
            }
        }

    s.promptbox = awful.widget.prompt()
    clock = wibox.widget.textclock()

    awesomemenu = {
        { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
        { "Reload", awesome.restart },
        { "Quit", function() awesome.quit() end },
    }

    appmenu = {
        { "Terminal", function() awful.spawn.with_shell("alacritty") end },
        { "Editor", function() awful.spawn.with_shell("emacs") end },
    }

    scriptmenu = {}

    mainmenu = awful.menu({
        items = {
            {"AwesomeWM", awesomemenu, beautiful.awesomemenu},
            {"Apps", appmenu, beautiful.app},
        }
    })

    launcher = awful.widget.launcher({image = beautiful.ghost, menu = mainmenu})

    local current_screen_width = s.geometry.width
    local wibar_width = (current_screen_width / 100) * 80;

    s.wibar = awful.wibar({
        position = "top",
        x = 0,
        y = 0,
        screen = s,
        height = 30,
        width = wibar_width,
        visible = true,
        type = "dock",
        shape = function(cr, w, h, r) gears.shape.octogon(cr, w, h, 0) end,
        stretch = false,
        bg = beautiful.bg_normal
    })

    s.wibar.x = s.geometry.x + ((s.geometry.width/2)-(wibar_width/2))
    s.wibar.y = 10

    s.focused_screen = wibox.widget {
        widget = wibox.widget.textbox,
        text = "-1",
        font = "Rboto 15",
        align = "center",
        forced_height = dpi(32),
    }


    s.focused_screen:set_text(awful.screen.focused().index)

    awesome.connect_signal("screen_focus_changed", function ()
        s.focused_screen:set_text(awful.screen.focused().index)
    end)

    s.wibar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- left widgets
            layout = wibox.layout.fixed.horizontal,
            launcher,
            helpers.icon_label("", s.focused_screen),
            wibox.widget {
                widget = wibox.widget.separator,
                forced_width = 20,
                opacity = 0
            },
            s.taglist,
            wibox.widget {
                widget = wibox.widget.separator,
                forced_width = 25,
                opacity = 0
            },
            s.promptbox
        },
        {
            layout = wibox.layout.fixed.horizontal,
            {
                s.tasklist,
                shape = function(cr, w, h, r) gears.shape.rounded_rect(cr, w, h, 20) end,
                widget = wibox.container.background
            }
        },
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 10,
            clock,
            wibox.layout.margin(wibox.widget.systray(), 7, 7, 7, 7),
            wibox.layout.margin(s.layoutbox, 7, 7, 7, 7),
            wibox.widget {
                widget = wibox.widget.separator,
                forced_width = 1,
                opacity = 0
            }
        }
    }

end)
