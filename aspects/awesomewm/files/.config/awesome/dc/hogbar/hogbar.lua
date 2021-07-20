local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local menubar = require('menubar')
local utils = require('utils')
-- local capi = { screen = screen }

local make_left_widget = require('dc.hogbar.left_widget')
local make_right_widget = require('dc.hogbar.right_widget')

local home = os.getenv('HOME')
local terminal = "alacritty"
local editor = "nvim"
local editor_cmd = terminal .. ' -e ' .. editor

-- awful.layout.layouts = {
--    awful.layout.suit.tile
-- }

menubar.utils.terminal = terminal

local mytextclock = wibox.widget.textclock("%H:%M %A %d %B")
mytextclock.font = "Roboto 11"

local function make_hogbar(args)
   local s = args.screen
   local hogbar_height = args.height
   local left_widget = args.left_widget or nil
   local middle_widget = args.middle_widget or nil
   local right_widget = args.right_widget or nil

   local hogbar = awful.wibar({
	 position = "top",
	 screen = s,
	 height = 32,
     width  = s.geometry.width - 40,
	 type = "dock",
	 -- bg = '#000000CA',
	 fg = beautiful.fg,
   })

   hogbar:setup({
	 layout = wibox.layout.manual,
	 { -- Left bar thing
	    point = { x = 0, y = 0 },
	    forced_width = 282,
	    forced_height = hogbar_height - 10,
	    bg = "#E5E9F0",
	    type = 'bar',
	    shape = utils.rrect(6),
	    widget = wibox.container.background,
	    {
	       layout = wibox.layout.fixed.horizontal,
	       {
		  widget = wibox.container.margin,
		  top = 6,
		  bottom = 6,
		  left = 6,
		  left_widget,
	       },
	    },
	 },
    {
       point = { x = ((1920/2)-85), y = 0 },
       forced_width = 170,
       forced_height = hogbar_height - 10,
       bg = "#E5E9F0",
       fg = "#3B4252",
       type = 'bar',
       shape = utils.rrect(6),
       widget = wibox.container.background,
       {
          layout = wibox.layout.fixed.horizontal,
          {
             widget = wibox.container.margin,
             top = 6,
             bottom = 6,
             left = 6,
             middle_widget
          }
       }
    },
	 { -- Right bar thing
	    point = { x = awful.screen.focused().geometry.width - 200, y = 0 },
	    forced_width = 160,
	    forced_height = hogbar_height - 10,
	    bg = "#E5E9F0",
	    type = 'dock',
	    shape = utils.rrect(6),
	    widget = wibox.container.background,
	    {
	       widget = wibox.container.margin,
	       right = 10,
	       {
		  widget = wibox.container.place,
		  halign = "right",
		  {
		     layout = wibox.layout.fixed.horizontal,
		     right_widget
		  }
	       },
	    },
	 },
   })

   local bar = wibox.widget({
           layout = wibox.layout.fixed.horizontal,
           {
               widget = wibox.container.margin,
               top = 20,
               {
                   widget = wibox.container.background,
                   bg = "#FF0000",
                   {
                        widget = wibox.layout.fixed.horizontal,
                        -- hogbar
                   }
               }
           },
   })

   return bar
end

-- awful.screen.connect_for_each_screen(function(s)
--    local names = { '1', '2', '3', '4', '5', '6', '7', '8', '9' }
--    awful.tag(names, s, awful.layout.layouts[1])

--    -- make_hogbar({
--    --    screen = s,
--    --    height = 45,
--    --    left_widget = make_left_widget({
--    --      screen = s,
--    --      taglist_width = 300,
--    --    }),
--    --    middle_widget = mytextclock,
--    --    right_widget = make_right_widget(s)
--    -- })
-- end)
