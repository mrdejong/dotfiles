local gears = require('gears')
local awful = require('awful')
-- local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- A war with LSP!
local awesome = _G['awesome']
local client = _G['client']
local mymainmenu = _G['mymainmenu']

modkey = "Mod4"

function bind(key, func, group, desc, mask)
  local master = {modkey}

  if mask ~= "" then
    master = {modkey, mask}
  end

  return awful.key(master, key, func, { description=desc, group=group })
end

function bind_awesome(key, func, desc, mask)
  mask = mask or ""
  return bind(key, func, "awesome", desc, mask)
end

function bind_tag(key, func, desc)
  return bind(key, func, "tag", desc, "")
end

function bind_client(key, func, desc, mask)
  mask = mask or ""
  return bind(key, func, "client", desc, mask)
end

function bind_screen(key, func, desc, mask)
  mask = mask or ""
  return bind(key, func, "screen", desc, mask)
end

function bind_launcher(key, func, desc, mask)
  mask = mask or ""
  return bind(key, func, "launcher", desc, mask)
end

function bind_layout(key, func, desc, mask)
  mask = mask or ""
  return bind(key, func, "layout", desc, mask)
end

function bind_client(key, func, desc, mask)
  mask = mask or ""
  return bind(key, func, "client", desc, mask)
end

function focus_client(idx)
  return function ()
    awful.client.focus.byidx(idx)
  end
end

function spawn(program)
  return function ()
    awful.spawn(program)
  end
end

local go_back = function ()
  awful.client.focus.history.previous()
  if client.focus then
    client.focus:raise()
  end
end

globalkeys = gears.table.join(
  bind_awesome("s", hotkeys_popup.show_help, "Show help"),
  bind_awesome("w", function() mymainmenu:show() end, "show main menu"),
  bind_awesome("r", awesome.restart, "reload awesome", "Control"),
  bind_awesome("q", awesome.quit, "quit awesome", "Shift"),

  -- Tag keys
  bind_tag("Left", awful.tag.viewprev, "view PreVious"),
  bind_tag("Right", awful.tag.viewnext, "view next"),
  bind_tag("Escape", awful.tag.history.restore, "go back"),

  -- Client keys
  bind_client("j", focus_client( 1), "focus next by index"),
  bind_client("k", focus_client(-1), "focus previous by index"),
  bind_client("j", function() awful.client.swap.byidx( 1) end, "swap with next client by index", "Shift"),
  bind_client("k", function() awful.client.swap.byidx(-1) end, "swap with previous client by index", "Shift"),
  bind_client("u", awful.client.urgent.jumpto, "jump to urgent cleint"),
  bind_client("Tab", go_back, "go back"),

  -- Screen keys
  bind_screen("j", function() awful.screen.focus_relative( 1) end, "focus the next screen", "Control"),
  bind_screen("k", function() awful.screen.focus_relative(-1) end, "focus the previous screen", "Control"),

  -- Layout keys
  bind_layout("l", function () awful.tag.incmwfact( 0.05) end, "increase master width factor"),
  bind_layout("h", function () awful.tag.incmwfact(-0.05) end, "decrease master width factor"),
  bind_layout("h", function () awful.tag.incnmaster( 1, nil, true) end, "increase the number of master clients", "Shift"),
  bind_layout("l", function () awful.tag.incnmaster(-1, nil, true) end, "decrease the number of master clients", "Shift"),
  bind_layout("h", function () awful.tag.incncol( 1, nil, true) end, "increase the number of columns", "Control"),
  bind_layout("l", function () awful.tag.incncol(-1, nil, true) end, "decrease the number of columns", "Control"),
  bind_layout("space", function () awful.layout.inc( 1) end, "select next"),
  bind_layout("space", function () awful.layout.inc(-1) end, "select previous", "Shift"),

  -- Launcher keys
  bind_launcher("Return", spawn(terminal), "open a terminal"),
  bind_launcher("p", spawn("rofi -show run"), "run dmenu"),
  bind_launcher("b", spawn("brave"), "launch browser"),
  bind_launcher("e", spawn("emacsclient -c"), "launch emacs")
  -- bind_launcher("s", spawn("spotify"), "launch spotify")
)

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

--     -- Prompt
--     awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
--               {description = "run prompt", group = "launcher"}),

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
--     -- Menubar
--     awful.key({ modkey }, "p", function() menubar.show() end,
--               {description = "show the menubar", group = "launcher"})
-- )

local close_client = function(c) c:kill() end
local swap_client = function(c) c:swap(awful.client.getmaster()) end
local move_to_screen = function(c) c:move_to_screen() end
local ontop = function (c) c.ontop = not c.ontop end
local fullscreen = function (c)
  c.fullscreen = not c.fullscreen
  c:raise()
end
local toggle_maximize = function(c)
  c.maximized = not c.maximized
  c:raise()
end
local toggle_maximize_vertical = function(c)
  c.maximized_vertical = not c.maximized_vertical
  c:raise()
end
local toggle_maximize_horizontal = function(c)
  c.maximized_horizontal = not c.maximized_horizontal
  c:raise()
end

-- Keep this around if I ever want this back...
-- awful.key({ modkey,           }, "n",
--   function (c)
--     -- The client currently has the input focus, so it cannot be
--     -- minimized, since minimized clients can't have the focus.
--     c.minimized = true
--   end ,
--   {description = "minimize", group = "client"}),

clientkeys = gears.table.join(
    bind_client("f", fullscreen, "Toggle fullscreen"),
    bind_client("c", close_client, "Close"),
    bind_client("space", awful.client.floating.toggle, "Toggle floating", "Control"),
    bind_client("Return", swap_client, "Move to master", "Control"),
    bind_client("o", move_to_screen, "Move to screen"),
    bind_client("t", ontop, "Toggle keep on top"),
    bind_client("m", toggle_maximize, "(un)maximize"),
    bind_client("m", toggle_maximize_vertical, "(un)maximize vertically", "Control"),
    bind_client("m", toggle_maximize_horizontal, "(un)maximize horizontally", "Shift")
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
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
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

return {global = globalkeys, client = clientkeys}
