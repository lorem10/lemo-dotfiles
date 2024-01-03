local wibox        = require("wibox")
local gears        = require("gears")

local xresources          = require("beautiful.xresources")
local dpi                 = xresources.apply_dpi

local filesystem   = gears.filesystem
local theme_dir    = filesystem.get_configuration_dir() .. '/theme'

local systray_icon = wibox.widget {
  image = theme_dir .. '/icons/chevron-up.svg', -- You can replace this with an appropriate icon
  widget = wibox.widget.imagebox,
}


local systray           = wibox.widget {
  widget = wibox.container.background,
  bg = "#000000",
  {
    widget  = wibox.container.margin,
    margins = dpi(3),
    shape   = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 3)
    end,
    wibox.widget.systray(),
  }
}
systray.visible         = false

local systray_container = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  systray,
  {
    widget = wibox.container.margin,
    margins = dpi(4),
    systray_icon,
  }
}
local toggle_systray    = function()
  if systray.visible == true then
    systray.visible = false
    systray_icon.image = theme_dir .. '/icons/chevron-up.svg'
  else
    systray_icon.image = theme_dir .. '/icons/chevron-left.svg'
    systray.visible = true
  end
end

systray_icon:connect_signal("button::press", function()
  toggle_systray()
end)








awesome.connect_signal(
  'widget::systray:toggle',
  function()
    toggle_systray()
  end
)


return systray_container
