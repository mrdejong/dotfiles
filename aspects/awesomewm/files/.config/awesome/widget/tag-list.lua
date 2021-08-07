local awful               = require('awful')
local wibox               = require('wibox')
local beautiful           = require('beautiful')
local dpi                 = require('beautiful').xresources.apply_dpi
local capi                = {
    button = _G.button
}
local clickable_container = require('widget.material.clickable-container')
local modkey              = require('configuration.keys.mod').modKey
local utils               = require('utils')


local function create_buttons(buttons, object)
    if buttons then
        local btns = {}
        for _, b in ipairs(buttons) do
            local btn = capi.button {
                modifiers = b.modifiers,
                button = b.button
            }

            btn:connect_signal('press', function ()
                b:emit_signal('press', object)
            end)

            btn:connect_signal('release', function ()
                b:emit_signal('release', object)
            end)

            btns[#btns+1] = btn
        end

        return btns
    end
end

local function list_update(w, buttons, label, data, objects)
    -- update the widgets, creating them if needed
    w:reset()
    for i, o in ipairs(objects) do
        local cache = data[o]
        local ib, tb, bgb, tbm, ibm, l, bg_clickable
        if cache then
            ib = cache.ib
            tb = cache.tb
            bgb = cache.bgb
            tbm = cache.tbm
            ibm = cache.ibm
        else
            ib = wibox.widget.textbox()
            tb = wibox.widget.textbox()
            bgb = wibox.container.background()
            tbm = wibox.container.margin(tb, dpi(6), dpi(6), dpi(4), dpi(4))
            ibm = wibox.container.margin(ib, dpi(6), dpi(9), dpi(6), dpi(6))
            l = wibox.layout.fixed.horizontal()
            bg_clickable = clickable_container()

            ib.font = "Hack Nerd Font 14" --beautiful.icon_font
            ib.forced_width = dpi(22)
            ib.forced_height = dpi(22)
            ib.align = 'center'
            ib.valign = 'center'

            -- ibm.shape = utils.rrect(dpi(5))

            -- All of this is added in a fixed widget
            l:fill_space(true)
            l:add(ibm)
            l:add(tbm)
            bg_clickable:set_widget(l)

            -- And all of this gets a background
            bgb:set_widget(bg_clickable)

            bgb:buttons(create_buttons(buttons, o))

            data[o] = {
                ib = ib,
                tb = tb,
                bgb = bgb,
                tbm = tbm,
                ibm = ibm
            }
        end


        local tag_data = _G.tags[o.screen.index][o.index]

        -- _G.awesome.emit_signal('debug::error', o.screen.index)

        local text, bg, bg_image, icon, args = label(o, tb)
        args = args or {}

        if text == nil or text == '' then
            tbm:set_margins(0)
        else
            if not tb:set_markup_silently(text) then
                tb:set_markup('<i>&lt;Invalid text&gt;</i>')
            end
        end
        bgb:set_bg(bg)
        -- if type(bg_image) == 'function' then
        --     bg_image = bg_image(tb, o, nil, objects, i)
        -- end
        -- bgb:set_bgimage(bg_image)
        if tag_data.icon then
            tbm.visible = false
            ib:set_text(tag_data.icon)
        else
            ibm.visible = false
        end
        -- if icon then
        --     -- ib:set_text(icon)
        -- else
        --     ibm:set_margins(0)
        -- end

        bgb.shape = args.shape

        w:add(bgb)
    end
end

local TagList = function(s)
    return awful.widget.taglist(s, awful.widget.taglist.filter.all,
               awful.util.table.join(awful.button({}, 1, function(t)
            t:view_only()
            -- _G._splash_to_current_tag()
        end), awful.button({modkey}, 1, function(t)
            if _G.client.focus then
                _G.client.focus:move_to_tag(t)
                t:view_only()
            end
            -- _G._splash_to_current_tag()
        end), awful.button({modkey}, 3, function(t)
            if _G.client.focus then
                _G.client.focus:toggle_tag(t)
            end
            -- _G._splash_to_current_tag()
        end), awful.button({}, 4, function(t)
            awful.tag.viewprev(t.screen)
            -- _G._splash_to_current_tag()
        end), awful.button({}, 5, function(t)
            awful.tag.viewnext(t.screen)
            -- _G._splash_to_current_tag()
        end)), {spacing = dpi(4)}, list_update, wibox.layout.fixed.horizontal())
end

return TagList
