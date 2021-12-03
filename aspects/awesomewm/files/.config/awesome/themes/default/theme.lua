---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources   = require("beautiful.xresources")
local gears        = require("gears")
local lain         = require("lain")
local awful        = require("awful")
local wibox        = require("wibox")
local dpi          = xresources.apply_dpi

local gfs              = require("gears.filesystem")
--    local themes_path = gfs.get_themes_dir()
local themes_path       = gfs.get_configuration_dir() .. "themes/"
local wallpaper_folder  = "~/.wallpaper/"
local my_table          = awful.util.table or gears.table

local theme = {}

theme.font          = "Ubuntu 12"

theme.dir                  = themes_path .. 'default/'
theme.widget_ac            = theme.dir .. "icons/ac.png"
theme.widget_battery       = theme.dir .. "icons/battery.png"
theme.widget_battery_low   = theme.dir .. "icons/battery_low.png"
theme.widget_battery_empty = theme.dir .. "icons/battery_empty.png"
theme.widget_mem           = theme.dir .. "icons/mem.png"
theme.widget_cpu           = theme.dir .. "icons/cpu.png"
theme.widget_temp          = theme.dir .. "icons/temp.png"
theme.widget_net           = theme.dir .. "icons/net.png"
theme.widget_hdd           = theme.dir .. "icons/hdd.png"
theme.widget_music         = theme.dir .. "icons/note.png"
theme.widget_music_on      = theme.dir .. "icons/note_on.png"
theme.widget_vol           = theme.dir .. "icons/vol.png"
theme.widget_vol_low       = theme.dir .. "icons/vol_low.png"
theme.widget_vol_no        = theme.dir .. "icons/vol_no.png"
theme.widget_vol_mute      = theme.dir .. "icons/vol_mute.png"
theme.widget_mail          = theme.dir .. "icons/mail.png"
theme.widget_mail_on       = theme.dir .. "icons/mail_on.png"

-- theme.bg_normal     = "#222222"
theme.bg_normal   = "#151B1EE6"
theme.bg_focus    = "#151B1EE6"
theme.bg_urgent   = "#151B1E"
theme.bg_minimize = "#c8cca7"
theme.bg_systray  = theme.bg_normal

theme.fg_normal   = "#DDDDFF"
theme.fg_focus    = "#EA6f81"
theme.fg_urgent   = "#CC9393"
theme.fg_minimize = "#ffffff"

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(2)
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#CC9393"
theme.border_marked = "#CC9393"

theme.tasklist_bg_normal       = "#151b1e00"
theme.tasklist_bg_focus        = "#151b1e00"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon    = true

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )
theme.taglist_font = "Hack Nerd Font Mono 16"
theme.taglist_width = dpi(32)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_max_width = dpi(500)
theme.notification_icon_size = dpi(120)

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height       = dpi(15)
theme.menu_width        = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active   = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active    = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active   = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active    = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active   = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active    = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path.."default/titlebar/maximized_focus_active.png"

theme.wallpaper = wallpaper_folder.."current"

-- You can use your own layout icons like this:
theme.layout_tile       = theme.dir .. "/icons/tile.png"
theme.layout_tileleft   = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop    = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv      = theme.dir .. "/icons/fairv.png"
theme.layout_fairh      = theme.dir .. "/icons/fairh.png"
theme.layout_spiral     = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle    = theme.dir .. "/icons/dwindle.png"
theme.layout_max        = theme.dir .. "/icons/max.png"
theme.layout_fullscreen = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier  = theme.dir .. "/icons/magnifier.png"
theme.layout_floating   = theme.dir .. "/icons/floating.png"
theme.layout_cornernw   = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne   = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw   = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse   = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

local markup = lain.util.markup
local separators = lain.util.separators

local keyboardlayout = awful.widget.keyboardlayout:new()

local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +'%a %d %R'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

theme.cal = lain.widget.cal({
    attach_to = {clock},
    notification_preset = {
        font = "Source Code Pro 10",
        fg = theme.fg_normal,
        bg = theme.bg_normal
    }
})

local memicon = wibox.widget.imagebox(theme.widget_mem) 
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "°C "))
    end
})

local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                baticon:set_image(theme.widget_ac)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(theme.widget_battery_low)
            else
                baticon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(theme.font, " AC "))
            baticon:set_image(theme.widget_ac)
        end
    end
})

local spr = wibox.widget.textbox('┃')
local space = wibox.widget.textbox('  ')

function theme.at_screen_connect(s)
    s.quake = lain.util.quake({ app = awful.util.terminal })

    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))

     -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(25), bg = theme.bg_normal, fg = theme.fg_normal })

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            space,
            space,
            space,
            s.mypromptbox
        },
        s.mytasklist,
        {
            layout  = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            space,
            space,
            memicon,
            mem.widget,
            spr,
            cpuicon,
            cpu,
            spr,
            tempicon,
            temp,
            spr,
            baticon,
            bat.widget,
            clock,
            wibox.container.background(s.mylayoutbox, theme.temp_color)
        }
    }
end

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
