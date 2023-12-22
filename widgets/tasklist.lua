local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

-- TODO: splite this code to another component
local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        { raise = true }
      )
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end))

local function setup_tasklist(s)
  return awful.widget.tasklist {
    screen          = s,
    filter          = awful.widget.tasklist.filter.currenttags,
    buttons         = tasklist_buttons,
    layout          = {
      layout = wibox.layout.fixed.horizontal,
      spacing = 7,
    },
    style           = {
      shape = function(cr, width, height)
        gears.shape.rounded_bar(cr, 36, 36)
      end,
      bg    = "#ffffff20",
    },
    widget_template = {
      {
        {
          {
            {
              id            = 'icon_role',
              widget        = wibox.widget.imagebox,
              forced_height = 20,
              forced_width  = 20,
            },
            margins = 2,
            widget  = wibox.container.margin,
            layout  = wibox.layout.flex.horizontal,
          },
          layout = wibox.layout.flex.horizontal,
        },
        top    = 7,
        left   = 8,
        right  = 8,
        widget = wibox.container.margin,

      },
      id     = 'background_role',
      widget = wibox.container.background,
    },
  }
end


return {
  setup_tasklist = setup_tasklist
}
