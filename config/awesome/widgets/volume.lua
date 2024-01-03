local wibox      = require("wibox")
local gears      = require("gears")
local awful      = require("awful")

local xresources          = require("beautiful.xresources")
local dpi                 = xresources.apply_dpi

local filesystem = gears.filesystem
local theme_dir  = filesystem.get_configuration_dir() .. '/theme'


local icon             = wibox.widget {
  margins = dpi(3),
  widget = wibox.container.margin,
  {
    widget = wibox.widget.imagebox,
    image = theme_dir .. "/icons/volume-up.svg"
  },
}

local percentText      = wibox.widget {
  left = dpi(2),
  widget = wibox.container.margin,
  {
    widget = wibox.widget.textbox,
  }
}

local volume_container = wibox.widget {
  layout = wibox.layout.align.horizontal,
  nil,
  icon,
  percentText,
}

local update_volume    = function()
  awful.spawn.easy_async_with_shell(
    [[sleep 0.1;bash -c "amixer -D pulse sget Master"]],
    function(stdout)
      local volume = string.match(stdout, '(%d?%d?%d)%%')
      local isMuted = string.match(stdout, '%[off%]')

      if isMuted then
        icon.widget.image = theme_dir .. "/icons/volume-x.svg"
        percentText.widget:set_markup_silently("Mute")
      else
        icon.widget.image = theme_dir .. "/icons/volume-up.svg"
        percentText.widget:set_markup_silently((tonumber(volume) or 0) .. '%')
      end
    end
  )
end




update_volume()

awesome.connect_signal(
  'widget::volume:update',
  function()
    update_volume()
  end
)


return volume_container
