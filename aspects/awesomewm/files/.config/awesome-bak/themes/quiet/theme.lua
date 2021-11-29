---------------------------
-- Default awesome theme --
---------------------------

local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
-- local themes_path = gfs.get_configuration_dir() ..  "themes/"
local themes_path = string.format('%s/.config/awesome/themes/%s/theme.lua', os.getenv('HOME'), 'default')
local theme = dofile(themes_path)

local naughty = require("naughty")

-- local ruled = require("ruled")

local function dbug(msg)
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Debug",
                     message = msg
    })
end

-- dbug("theme loaded")

-- Fonts

local function font(s, t)
    local base = "Hack Nerd Font"

    s = s or '11'

    if t then
        return base .. " " .. t .. " " .. s
    else
        return base .. " " .. s
    end
end

theme.font_sized = font
theme.font = "Hack Nerd Font 11"
theme.new_colors = {
    bg       = "#E5E9F0",
    bgalt    = "#D8DEE9",
    base0    = "#F0F4FC",
    base1    = "#E3EAF5",
    base2    = "#D8DEE9",
    base3    = "#C2D0E7",
    base4    = "#B8C5DB",
    base5    = "#AEBACF",
    base6    = "#A1ACC0",
    base7    = "#60728C",
    base8    = "#485163",
    fg       = "#3B4252",
    fgalt    = "#2E3440",
    grey     = "#B8C5DB",
}

theme.colors = {
    white    = theme.new_colors.fgalt,
    grey     = "#B8C5DB",
    darkGrey = "#3c3836",
    black    = theme.new_colors.bgalt,

    red      = "#99324B",
    orange   = "#AC4426",
    green    = "#4F894C",
    teal     = "#29838D",
    yellow   = "#9A7500",
    blue     = "#3B6EA8",
    darkblue = "#5272AF",
    magenta  = "#97365B",
    violet   = "#842879",
    cyan     = "#398EAC",
    darkcyan = "#2C7088",
}

theme.si_weather_temp_font = font(16)
theme.si_weather_description_font = font(14)

theme.si_outer_border_color = theme.colors.green
theme.si_outer_border_width = dpi(0)

theme.si_inner_border_color = theme.colors.black .. '00'
theme.si_inner_border_width = dpi(0)
theme.si_inner_bg           = theme.colors.black .. '00'
theme.si_outer_bg           = theme.colors.black .. 'DD'
theme.si_cpu_graph_fg       = theme.colors.green
theme.si_cpu_graph_bg       = theme.colors.darkGrey .. '00'
theme.si_temp_font          = font('14', 'Bold')

-- Bar
theme.wibar_border_width = 0
theme.wibar_border_color = theme.new_colors.base8
theme.taglist_squares_sel = nil
theme.taglist_squares_unsel = nil
theme.taglist_squares_sel_empty = nil
theme.taglist_squares_unsel_empty = nil

-- Backgrounds

theme.bg_normal = theme.new_colors.bg
theme.bg_focus = theme.new_colors.base3
theme.bg_urgent = "#FF8080"
theme.bg_minimize = "#1F252A"
theme.bg_systray = theme.new_colors.bg

-- Foregrounds

theme.fg_normal = theme.new_colors.bg
theme.fg_focus = theme.colors.teal
theme.fg_urgent = "#D5D5D5"
theme.fg_minimize = "#C780FF"

-- Gap and borders

theme.useless_gap = dpi(10)
theme.gap_single_client = true
theme.border_width = dpi(3)
theme.border_color_normal = "#384149"
theme.border_color_active = "#384149"
theme.border_color_marked = "#384149"

-- Taglist
theme.taglist_bg = "#00000000"
theme.taglist_bg_empty = "#00000000"
theme.taglist_bg_occupied = "#00000000"

theme.taglist_fg = "#ECEFF4"
theme.taglist_fg_empty = "#ECEFF4"
theme.taglist_fg_occupied = "#ECEFF4"

-- Tasklist

theme.tasklist_bg_normal = "#1F252A"
theme.tasklist_align = "center"
theme.tasklist_disable_task_name = false
theme.tasklist_disable_icon = true

-- Titlebar

theme.titlebar_bg_focus = "#384149"
theme.titlebar_bg_normal = "#384149"

theme.titlebar_close_button_normal = gfs.get_configuration_dir() .. "themes/quiet/titlebar/inactive.png"
theme.titlebar_close_button_focus  = gfs.get_configuration_dir() .. "themes/quiet/titlebar/close.png"

theme.titlebar_minimize_button_normal = gfs.get_configuration_dir() .. "themes/quiet/titlebar/inactive.png"
theme.titlebar_minimize_button_focus  = gfs.get_configuration_dir() .. "themes/quiet/titlebar/minimize.png"

theme.titlebar_ontop_button_normal_inactive = gfs.get_configuration_dir() .. "themes/quiet/titlebar/inactive.png"
theme.titlebar_ontop_button_focus_inactive  = gfs.get_configuration_dir() .. "themes/quiet/titlebar/ontop.png"
theme.titlebar_ontop_button_normal_active = gfs.get_configuration_dir() .. "themes/quiet/titlebar/inactive.png"
theme.titlebar_ontop_button_focus_active  = gfs.get_configuration_dir() .. "themes/quiet/titlebar/ontop.png"

theme.titlebar_sticky_button_normal_inactive = gfs.get_configuration_dir() .. "themes/quiet/titlebar/inactive.png"
theme.titlebar_sticky_button_focus_inactive  = gfs.get_configuration_dir() .. "themes/quiet/titlebar/sticky.png"
theme.titlebar_sticky_button_normal_active = gfs.get_configuration_dir() .. "themes/quiet/titlebar/inactive.png"
theme.titlebar_sticky_button_focus_active  = gfs.get_configuration_dir() .. "themes/quiet/titlebar/sticky.png"

theme.titlebar_floating_button_normal_inactive = gfs.get_configuration_dir() .. "themes/quiet/titlebar/inactive.png"
theme.titlebar_floating_button_focus_inactive  = gfs.get_configuration_dir() .. "themes/quiet/titlebar/floating.png"
theme.titlebar_floating_button_normal_active = gfs.get_configuration_dir() .. "themes/quiet/titlebar/inactive.png"
theme.titlebar_floating_button_focus_active  = gfs.get_configuration_dir() .. "themes/quiet/titlebar/floating.png"

theme.titlebar_maximized_button_normal_inactive = gfs.get_configuration_dir() .. "themes/quiet/titlebar/inactive.png"
theme.titlebar_maximized_button_focus_inactive  = gfs.get_configuration_dir() .. "themes/quiet/titlebar/maximize.png"
theme.titlebar_maximized_button_normal_active = gfs.get_configuration_dir() .. "themes/quiet/titlebar/inactive.png"
theme.titlebar_maximized_button_focus_active  = gfs.get_configuration_dir() .. "themes/quiet/titlebar/maximize.png"

-- Wallpaper
theme.wallpaper = "~/linux-dotfiles/Pictures/Wallpaper/Cove.jpg"

-- Edge snap

theme.snap_bg = "#384149"
theme.snap_border_width = "5"

-- Icon theme

theme.icon_theme = "Papirus"

-- Menu
theme.menu_height = "25"
theme.menu_width = "200"
theme.menu_submenu = ""
theme.menu_submenu_icon = nil

theme.ghost = "~/.config/awesome/icons/pfp_trans.png"
theme.awesome_icon = "~/.config/awesome/icons/awesome.png"
theme.app = "~/.config/awesome/icons/app.png"
theme.terminal = "~/.config/awesome/icons/terminal.png"

-- Bling
theme.tabbed_spawn_in_tab = true
theme.tabbar_style = "modern"
theme.tabbar_position = "top"
theme.mstab_bar_padding = 0
theme.tabbar_size = 40
theme.tabbar_radius = 10
theme.tabbar_bg_normal = "#1f252a"
theme.tabbar_bg_focus = "#384149"

theme.flash_focus_start_opacity = 0.6
theme.flash_focus_step = 0.01

theme.tag_preview_widget_border_radius = 0
theme.tag_preview_client_border_radius = 0
theme.tag_preview_client_border_width = 0
theme.tag_preview_widget_border_width = 0
theme.tag_preview_client_opacity = 1
theme.tag_preview_widget_margin = 0
theme.tag_preview_client_bg = "#384149"
theme.tag_preview_widget_bg = "#1F252A"

-- Hotkey popup

local gears = require("gears")

theme.hotkeys_font = "Hack Nerd Font 11"
theme.hotkeys_description_font = "Hack Nerd Font 9"
theme.hotkeys_modifiers_fg = "#80D1FF"
theme.hotkeys_border_width = 15
theme.hotkeys_group_margin = 50
theme.hotkeys_border_color = "#1F252A"

-- Notifications

theme.notification_font = "Roboto 11"
theme.notification_bg = "#1F252A"
theme.notification_fg = "#D5D5D5"
theme.notification_margin = 20
naughty.config.defaults.margin = theme.notification_margin
naughty.config.defaults.padding = 20
naughty.config.defaults.position = "top_right"
theme.notification_border_width = 5
theme.notification_border_color = "#80D1FF"
theme.notification_width = 300
theme.notification_min_height = 60
theme.notification_max_width = 300

-- local rnotification = require("ruled.notification")
local ruled = require("ruled")

ruled.notification.append_rule {
    rule = {},
    properties = { icon_size = 100 }
}


return theme
