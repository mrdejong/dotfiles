local filesystem    = require('gears.filesystem')
local color_schemes = require('theme.color-schemes')
local theme_dir     = filesystem.get_configuration_dir() .. '/theme'
local dpi           = require('beautiful').xresources.apply_dpi
local theme         = {}

-- theme.scheme = color_schemes.gruvbox_material
theme.scheme = color_schemes.gruvbox

theme.primary = theme.scheme.primary
theme.accent  = theme.scheme.accent

local awesome_overrides = function (theme)
    theme.dir = theme_dir

    theme.icons     = theme_dir .. '/icons/'
    theme.font      = 'Hack Nerd Font 11'
    theme.icon_font = 'Hack Nerd Font 14'
    -- theme.icon_font = 'Material Icons Two Tone 14'

    theme.icon_battery_levels = { '', '', '', '', '', '' }

    theme.layout_txt_tile     = "舘"
    theme.layout_txt_max      = ""
    theme.layout_txt_floating = ""

    theme.taglist_font        = theme.font
    theme.taglist_bg_empty    = theme.primary.hue_100 .. '00'
    theme.taglist_bg_occupied = theme.primary.hue_200 .. '00'
    theme.taglist_fg_occupied = theme.accent.hue_100
    theme.taglist_bg_urgent   = 'linear:0,0:0,' .. dpi(48) .. ':0,' ..
        theme.accent.hue_700 .. ':0.07,' ..
        theme.accent.hue_700 .. ':0.07,' ..
        theme.primary.hue_100 .. ':1,' ..
        theme.primary.hue_100

    theme.taglist_bg_focus    = theme.accent.hue_200 --.. '00'
    theme.taglist_fg_focus    = theme.primary.hue_200

    theme.tasklist_font      = theme.font
    theme.tasklist_bg_normal = theme.primary.hue_100 .. '00'
    theme.tasklist_bg_focus  = theme.primary.hue_200
    theme.tasklist_bg_urgent = theme.primary.hue_200

    theme.icon_theme = 'Papirus'

    theme.gaps              = dpi(4)
    theme.border_width      = dpi(2)
    theme.border_focus      = theme.accent.hue_200
    theme.border_normal     = theme.primary.hue_100
    theme.gap_single_client = false
    theme.bg_normal         = theme.primary.hue_100
    theme.cursor_warp       = true
    theme.title_bar         = false
    theme.bg_systray        = theme.primary.hue_200 .. '00'
end

return {theme = theme, awesome_overrides = awesome_overrides}
