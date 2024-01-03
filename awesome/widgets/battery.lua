local wibox            = require("wibox")
local awful            = require("awful")

local naughty          = require("naughty")

local gears            = require("gears")

local filesystem       = gears.filesystem
local theme_dir        = filesystem.get_configuration_dir() .. '/theme'

-- Create a text widget to display battery information
local battery_text     = wibox.widget {
  widget = wibox.widget.textbox,
}

local icon             = wibox.widget {
  margins = 3,
  widget = wibox.container.margin,
  {
    widget = wibox.widget.imagebox,
    image = theme_dir .. "/icons/battery-0.svg"
  },
}

local get_battery_icon = function(level)
  if level >= 80 then
    return theme_dir .. '/icons/battery-100.svg'
  elseif level >= 40 then
    return theme_dir .. '/icons/battery-50.svg'
  elseif level <= 20 then
    return theme_dir .. '/icons/battery-0.svg'
  else
    return theme_dir .. '/icons/battery-50.svg'
  end
end

-- Function to update the battery text
local update_battery   = function()
  awful.spawn.easy_async("acpi", function(stdout)
    local battery_info = string.match(stdout, "(%d+)%%")
    local battery_level = tonumber(battery_info) or 0
    local battery_icon = get_battery_icon(battery_level)
    battery_text:set_text((battery_info .. '%' or "N/A"))
    icon.widget.image = battery_icon
  end)
end



-- Create a battery widget
local battery_widget = wibox.widget {
  icon,
  battery_text,
  layout = wibox.layout.fixed.horizontal,
}

-- Update battery text initially
update_battery()

-- Set up a timer to update the battery information periodically
local battery_timer = timer({ timeout = 60 }) -- Update every 60 seconds
battery_timer:connect_signal("timeout", update_battery)
battery_timer:start()

-- You can add this widget to your wibox
-- For example, add it to the right of the wibox
return battery_widget
