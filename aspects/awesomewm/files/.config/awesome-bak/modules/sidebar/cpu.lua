local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi

local cpu_graph = wibox.widget {
    max_value        = 100,
    background_color = beautiful.si_cpu_graph_bg,
    color            = beautiful.si_cpu_graph_fg,
    border_color     = beautiful.si_inner_border_color,
    border_width     = dpi(0.5), -- beautiful.si_inner_border_width,
    forced_height    = dpi(30),
    forced_width     = dpi(204),
    step_width       = dpi(6),
    step_spacing     = dpi(2),
    widget           = wibox.widget.graph
}

local cpu_label = wibox.widget {
    {
        text = "",
        font = "Hack Nerd Font 15",
        align = 'center',
        forced_width = dpi(50),
        widget = wibox.widget.textbox,
    },
    fg = beautiful.si_cpu_graph_fg,
    widget = wibox.container.background,
}

local total_prev, idle_prev = 0, 0
local function cpu_graph_update()
    local command = "cat /proc/stat | grep '^cpu '"
    awful.spawn.easy_async(command, function(stdout)
        local user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
            stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

        local total = user + nice + system + idle + iowait + irq + softirq + steal

        local diff_idle = idle - idle_prev
        local diff_total = total - total_prev
        local diff_usage = (1000*(diff_total-diff_idle)/diff_total+5)/10

        cpu_graph:add_value(diff_usage)

        if diff_usage <= 25 then
            cpu_graph.color = beautiful.colors.green
            cpu_label.fg = beautiful.colors.green
        elseif diff_usage > 25 and diff_usage <= 75 then
            cpu_graph.color = beautiful.colors.yellow
            cpu_label.fg = beautiful.colors.yellow
        else
            cpu_graph.color = beautiful.colors.red
            cpu_label.fg = beautiful.colors.red
        end

        total_prev = total
        idle_prev = idle
    end)
end

return {
    widget = {
        cpu_label,
        {
            cpu_graph,
            reflection = { horizontal = true },
            widget = wibox.container.mirror,
        },
        layout = wibox.layout.fixed.horizontal,
    },
    update = cpu_graph_update,
}
