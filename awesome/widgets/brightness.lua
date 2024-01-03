local wibox               = require("wibox")
local awful               = require("awful")
local gears               = require("gears")

local filesystem          = gears.filesystem
local theme_dir           = filesystem.get_configuration_dir() .. '/theme'
-- Change these paths to match your system's brightness control interface
local brightness_path     = "/sys/class/backlight/intel_backlight"
local brightness_cur_path = brightness_path .. "/brightness"
local brightness_max_path = brightness_path .. "/max_brightness"

-- Function to get the current brightness level
local get_brightness      = function(callback)
  awful.spawn.easy_async_with_shell(
    "sleep 0.1 && cat " .. brightness_cur_path,
    function(stdout)
      awful.spawn.easy_async_with_shell(
        "cat " .. brightness_max_path,
        function(stdout2)
          local brightness = tonumber(stdout)
          callback((brightness * 100) / tonumber(stdout2))
        end
      )
    end
  )
end


-- Create a text widget to display the brightness level
local brightness_text        = wibox.widget {
  widget = wibox.widget.textbox,
}

-- Function to update the brightness text
local update_brightness_text = function()
  get_brightness(function(brightness)
    brightness_text:set_text(brightness .. "%")
  end)
end

-- Create a brightness widget
local brightness_widget      = wibox.widget {
  {
    image = theme_dir .. '/icons/sun.svg', -- You can replace this with an appropriate icon
    widget = wibox.widget.imagebox,
  },
  brightness_text,
  layout = wibox.layout.fixed.horizontal,
}

-- Update brightness text initially
update_brightness_text()


awesome.connect_signal(
  'widget::brightness:update',
  function()
    update_brightness_text()
  end
)

-- You can add this widget to your wibox
-- For example, add it to the right of the wibox
return brightness_widget
