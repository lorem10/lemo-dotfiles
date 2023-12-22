local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local mylauncher = require("widgets.luancher")
local mytasklist = require("widgets.tasklist")
local mytaglist = require("widgets.taglist")
local screen_geometry = awful.screen.focused().geometry
local screen_width = screen_geometry.width
local screen_height = screen_geometry.height


mykeyboardlayout = awful.widget.keyboardlayout()
mytextclock = wibox.widget.textclock()


local function setup_wibar(s)
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function() awful.layout.inc(1) end),
    awful.button({}, 3, function() awful.layout.inc(-1) end),
    awful.button({}, 4, function() awful.layout.inc(1) end),
    awful.button({}, 5, function() awful.layout.inc(-1) end)))

  s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 50 })
  s.centerwibox = wibox({
    ontop    = false,
    screen   = s,
    bg       = "#ffffff00",
    height   = 18,
    width    = 340,
    type     = "desktop",
    visible  = true,
    y        = screen_height - 34,
    x        = (screen_width / 2) - (340 / 2),
    shape    = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 5)
    end,
    position = "bottom",
  })

  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      {
        layout = wibox.layout.fixed.horizontal,
        {

          widget = wibox.container.margin,
          top = 12,
          bottom = 12,
          right = 20,
          left = 12,
          mylauncher,
        },
        {

          widget = wibox.container.margin,
          top = 7,
          mytasklist.setup_tasklist(s)
        },
      }
    },
    { -- center
      layout = wibox.layout.fixed.horizontal,
      {
        widget = wibox.container.margin,
        margins = 12,
      }
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      {
        widget = wibox.container.margin,
        margins = 12,
        wibox.widget.systray(),

      },
      mykeyboardlayout,
      {
        widget = wibox.container.margin,
        margins = 12,
        mytextclock,

      },
      {
        widget = wibox.container.margin,
        margins = 12,
        s.mylayoutbox,
      },
    },
  }
  s.centerwibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- left
      layout = wibox.layout.fixed.horizontal,
      {
        widget = wibox.container.margin,
        margins = 12,
      }
    },
    mytaglist.setup_taglist(s),
    { -- Left center
      layout = wibox.layout.fixed.horizontal,
      {
        widget = wibox.container.margin,
        margins = 12,
      }
    },

  }
end

return {
  setup_wibar = setup_wibar
}
