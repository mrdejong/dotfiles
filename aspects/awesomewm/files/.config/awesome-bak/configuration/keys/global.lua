require('awful.autofocus')
local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup').widget
local modkey = require('configuration.keys.mod').modKey
local menubar       = require("menubar")

local emacs = "emacsclient -a 'emacs' -c"

local function bind(key, group)
    local opts = {
        description = key.description or key.desc,
        group = group
    }
    local mods = key.modifiers or { modkey }
    return awful.key(mods, key.key, key.action, opts)
end

local awesome_keys = {
    {
        key = "s",
        action = hotkeys_popup.show_help,
        description = "Show help"
    },
    {
        key = "r",
        modifiers = { modkey, "Control" },
        action = _G.awesome.restart,
        description = "Reload awesome"
    },
    {
        key = "q",
        modifiers = { modkey, "Shift" },
        action = _G.awesome.quit,
        description = "Quit awesome"
    }
}

local tag_keys = {
    {
        key = "Left",
        action = awful.tag.viewprev,
        description = "View previous"
    },
    {
        key = "Right",
        action = awful.tag.viewnext,
        description = "View next"
    },
    {
        key = "Escape",
        action = awful.tag.history.restory,
        description = "Go back"
    }
}

--     awful.key({ modkey,           }, "Tab",
--         function ()
--             awful.client.focus.history.previous()
--             if client.focus then
--                 client.focus:raise()
--             end
--         end,
--         {description = "go back", group = "client"}),
--     awful.key({ modkey, "Control" }, "n",
--               function ()
--                   local c = awful.client.restore()
--                   -- Focus restored client
--                   if c then
--                     c:emit_signal(
--                         "request::activate", "key.unminimize", {raise = true}
--                     )
--                   end
--               end,
--               {description = "restore minimized", group = "client"}),
local client_keys = {
    {
        key = "j",
        action = function() awful.client.focus.byidx(1) end,
        description = "Focus next by index"
    },
    {
        key = "k",
        action = function() awful.client.focus.byidx(-1) end,
        description = "Focus previous by index"
    },
    {
        key = "j",
        modifiers = { modkey, "Shift" },
        action = function() awful.client.swap.byidx(1) end,
        description = "Swap with next client by index"
    },
    {
        key = "k",
        modifiers = { modkey, "Shift" },
        action = function() awful.client.swap.byidx(-1) end,
        description = "Swap with previous client by index"
    },
    {
        key = "u",
        action = awful.client.urgent.jumpto,
        description = "Jump to urgent client"
    }
}

local launcher_keys = {
    {
        key = "p",
        action = function() menubar.show() end,
        description = "Show the menubar"
    },
    {
        key = "space",
        action = function() awful.spawn.with_shell("rofi -show drun -display-drun 'App Launcher' -dpi 196") end,
        description = "Open launcher"
    },
    {
        key = "Return",
        action = function() awful.spawn('alacritty') end,
        description = "Open terminal"
    },
    {
        key = "e",
        modifiers = { modkey, "Mod1" },
        action = function() awful.spawn(emacs) end,
        description = "Launch emacs"
    }
}

local screen_keys = {
    {
        key = "j",
        modifiers = { modkey, "Control" },
        action = function() awful.screen.focus_relative(1) end,
        description = "Focus the next screen"
    },
    {
        key = "k",
        modifiers = { modkey, "Control" },
        action = function() awful.screenfocus_relative(-1) end,
        description = "Focus the previous screen"
    }
}

local layout_keys = {
    {
        key = "l",
        action = function() awful.tag.incmwfact(0.05) end,
        description = "Increase master width factor"
    },
    {
        key = "h",
        action = function() awful.tag.incmwfact(-0.05) end,
        description = "Decrease master width factor"
    },
    {
        key = "h",
        modifiers = { modkey, "Shift" },
        action = function() awful.tag.incnmaster(1, nil, true) end,
        description = "Increase the number of master clients"
    },
    {
        key = "l",
        modifiers = { modkey, "Shift" },
        action = function() awful.tag.incnmaster(-1, nil, true) end,
        description = "Decrease the number of master clients"
    },
    {
        key = "h",
        modifiers = { modkey, "Control" },
        action = function() awful.tag.incncol(1, nil, true) end,
        description = "Increase the number of columns"
    },
    {
        key = "l",
        modifiers = { modkey, "Control" },
        action = function() awful.tag.incncol(-1, nil, true) end,
        description = "Decrease the number of columns"
    },
    {
        key = "space",
        modifiers = { modkey, "Mod1" },
        action = function() awful.layout.inc(1) end,
        description = "Select next"
    },
    {
        key = "space",
        modifiers = { modkey, "Shift" },
        action = function() awful.layout.inc(-1) end,
        description = "Select previous"
    }
}

local globalkeys

for _, k in ipairs(awesome_keys) do
    globalkeys = awful.util.table.join(bind(k, "awesome"), globalkeys)
end

for _, k in ipairs(tag_keys) do
    globalkeys = awful.util.table.join(bind(k, "tags"), globalkeys)
end

for _, k in ipairs(client_keys) do
    globalkeys = awful.util.table.join(bind(k, "client"), globalkeys)
end

for _, k in ipairs(launcher_keys) do
    globalkeys = awful.util.table.join(bind(k, "launcher"), globalkeys)
end

for _, k in ipairs(screen_keys) do
    globalkeys = awful.util.table.join(bind(k, "screen"), globalkeys)
end

for _, k in ipairs(layout_keys) do
    globalkeys = awful.util.table.join(bind(k, "layout"), globalkeys)
end

for i = 1, 9 do
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {
            description = 'view tag #',
            group = 'tag'
        }
        descr_toggle = {
            description = 'toggle tag #',
            group = 'tag'
        }
        descr_move = {
            description = 'move focused client to tag #',
            group = 'tag'
        }
        descr_toggle_focus = {
            description = 'toggle focused client on tag #',
            group = 'tag'
        }
    end

    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if _G.client.focus then
                          local tag = _G.client.focus.screen.tags[i]
                          if tag then
                              _G.client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if _G.client.focus then
                          local tag = _G.client.focus.screen.tags[i]
                          if tag then
                              _G.client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

return globalkeys

-- keys.globalkeys = gears.table.join(
--     awful.key({modkey}, "`", function ()
--         awful.titlebar.toggle(_G.client.focus)
--     end, { description = "Toggle title bar", group = "AwesomeWM" }),
--     awful.key({modkey}, "c", function ()
--             modules.sidebar.toggle()
--     end),

--     -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
--     --           {description = "show main menu", group = "awesome"}),

--     -- Layout manipulation

--     -- Standard program



--     -- Prompt
--     awful.key({ modkey },            "r",     function () awful.prompt.run {
--                 prompt = "Run lua code: ",
--                 textbox = awful.screen.focused().promptbox.widget,
--                 exe_callback = awful.util.eval,
--                 history_path = awful.util.get_cache_dir() .. "/history_eval"
--     } end,
--               {description = "run prompt", group = "AwesomeWM"}),

--     awful.key({ modkey }, "x",
--               function ()
--                   awful.prompt.run {
--                     prompt       = "Run Lua code: ",
--                     textbox      = awful.screen.focused().mypromptbox.widget,
--                     exe_callback = awful.util.eval,
--                     history_path = awful.util.get_cache_dir() .. "/history_eval"
--                   }
--               end,
--               {description = "lua execute prompt", group = "awesome"}),



-- )

-- keys.clientkeys = gears.table.join(
--     awful.key({ modkey,           }, "f",
--         function (c)
--             c.fullscreen = not c.fullscreen
--             c:raise()
--         end,
--         {description = "toggle fullscreen", group = "client"}),
--     awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
--               {description = "close", group = "client"}),
--     awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
--               {description = "toggle floating", group = "client"}),
--     awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
--               {description = "move to master", group = "client"}),
--     awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
--               {description = "move to screen", group = "client"}),
--     awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
--               {description = "toggle keep on top", group = "client"}),
--     awful.key({ modkey,           }, "n",
--         function (c)
--             -- The client currently has the input focus, so it cannot be
--             -- minimized, since minimized clients can't have the focus.
--             c.minimized = true
--         end ,
--         {description = "minimize", group = "client"}),
--     awful.key({ modkey,           }, "m",
--         function (c)
--             c.maximized = not c.maximized
--             c:raise()
--         end ,
--         {description = "(un)maximize", group = "client"}),
--     awful.key({ modkey, "Control" }, "m",
--         function (c)
--             c.maximized_vertical = not c.maximized_vertical
--             c:raise()
--         end ,
--         {description = "(un)maximize vertically", group = "client"}),
--     awful.key({ modkey, "Shift"   }, "m",
--         function (c)
--             c.maximized_horizontal = not c.maximized_horizontal
--             c:raise()
--         end ,
--         {description = "(un)maximize horizontally", group = "client"})
-- )

-- -- Bind all key numbers to tags.
-- -- Be careful: we use keycodes to make it work on any keyboard layout.
-- -- This should map on the top row of your keyboard, usually 1 to 9.
-- for i = 1, tags do
--     keys.globalkeys = gears.table.join(keys.globalkeys,
--         -- View tag only.
--     )
-- end
