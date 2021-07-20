local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("utils")

local client = _G['client']

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

local make_left_widget = function (args)
   local taglist_width = args.taglist_width or 200
   local s = args.screen
   local mytaglist = awful.widget.taglist {
      screen = s,
      filter = awful.widget.taglist.filter.all,
      style = {
            bg_focus = '#C2D0E7',
            fg_focus = '#003040',
            fg_empty = '#3B4252',
            fg_occupied = '#3B4252',
            shape = utils.rrect(3),
            shape_border_width = 0,
            shape_border_width_focus = 0,
            shape_urgent
      },
      layout = { layout = wibox.layout.flex.horizontal, },
      widget_template = {
        id = "my_bg",
	 widget = wibox.container.background,
	 shape = utils.rrect(3),
	 forced_width = 30,
	 {
	    id = 'background_role',
	    widget = wibox.container.background,
	    forced_width = taglist_width / 9,
	    bg = '#1a1823',
	    {
	       widget = wibox.container.place,
	       {
		  id = "text_role",
		  font = "Ubuntu 10",
		  widget = wibox.widget.textbox,
	       }
	    },
	 },

	 create_callback = function(self, c3, index, objects) -- luacheck: no unused args
	    self:get_children_by_id("text_role")[1].markup = '<b> '..index..' </b>'
	    self:connect_signal('mouse::enter', function()
				   if self.bg ~= '#00000000' then
				      self.backup_bg = '#00000000'
				      self.backup_fg = '#ffffffff'
				   end
				   self.bg = '#B8C5DB'
				   self.fg = '#111111'
	    end)
	    self:connect_signal('mouse::leave', function()
				   if self.backup_bg then
				      self.bg = self.backup_bg
				      self.fg = self.backup_fg
				   end
	    end)
	 end,
	 update_callback = function (self, c3, index, objects)
	    self:get_children_by_id("text_role")[1].markup = '<b> '..index..'</b>'
	 end,
      },
      buttons = taglist_buttons
   }

   return mytaglist
end

return make_left_widget
