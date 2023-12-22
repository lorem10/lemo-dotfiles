local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local function setup_taglist(s)
  return awful.widget.taglist {
    screen          = s,
    filter          = awful.widget.taglist.filter.all,
    layout          = {
      spacing = 20,
      layout  = wibox.layout.fixed.horizontal,
    },
    style           = {
      shape              = function(cr, width, height)
        gears.shape.rounded_bar(cr, 14, 14)
      end,
      shape_border_width = 2,
      shape_border_color = "#ffffff",
      bg_focus           = "#ffffff"
    },
    widget_template = {
      {
        forced_width  = 16,
        forced_height = 18,
        widget        = wibox.widget.textbox,
        markup        = ""
      },
      id = 'background_role',


      widget          = wibox.container.background,
      create_callback = function(self, c3, index, objects) --luacheck: no unused args
        self:connect_signal('mouse::enter', function()
          if self.bg ~= '#ddd' then
            self.backup     = self.bg
            self.has_backup = true
          end
          self.bg = '#ddd'
        end)
        self:connect_signal('mouse::leave', function()
          if self.has_backup then self.bg = self.backup end
        end)
      end,
      update_callback = function(self, c3, index, objects) --luacheck: no unused args
      end,
    },
    buttons         = taglist_buttons,
  }
end



return {
  setup_taglist = setup_taglist
}
