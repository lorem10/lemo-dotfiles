local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")


local xresources          = require("beautiful.xresources")
local dpi                 = xresources.apply_dpi



local filesystem          = gears.filesystem
local theme_dir           = filesystem.get_configuration_dir() .. '/theme'

local brightness_path     = "/sys/class/backlight/intel_backlight"
local brightness_cur_path = brightness_path .. "/brightness"
local brightness_max_path = brightness_path .. "/max_brightness"

local percentText         = wibox.widget {
  margins = 0,
  widget = wibox.container.margin,
  {
    forced_width = dpi(70),
    widget = wibox.widget.textbox,
  }
}

local brightness_slider   = wibox.widget {
  widget              = wibox.widget.slider,
  bar_shape           = gears.shape.rounded_rect,
  bar_height          = 3,
  bar_color           = "#aaa",
  handle_color        = "#fff",
  handle_shape        = gears.shape.circle,
  handle_border_color = beautiful.border_color,
  handle_border_width = 0,
  handle_width        = dpi(15),
  value               = dpi(70),
}

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


local icon = wibox.widget {
  widget = wibox.container.margin,
  top = dpi(10),
  left = dpi(10),
  bottom = dpi(10),
  {
    resize = true,
    widget = wibox.widget.imagebox,
    image = theme_dir .. "/icons/sun.svg"
  },
}
local update_brightness = function()
  get_brightness(function(brightness)
    brightness_slider.value = brightness
  end)
end



brightness_slider:connect_signal(
  'property::value',
  function()
    local brightness_level = brightness_slider:get_value()
    awful.spawn('brightnessctl set ' .. brightness_level .. '%', false)
    awful.spawn('brightnessctl set 10-', false)

    -- Update textbox widget text
    -- osd_value.text = volume_level .. '%'

    -- Update the volume slider if values here change
    awesome.emit_signal('widget::brightness:update', brightness_level)

    -- if awful.screen.focused().show_vol_osd then
    --   awesome.emit_signal(
    --     'module::brightness_osd:show',
    --     true
    --   )
    -- end
  end
)


local hide_osd = gears.timer {
  timeout   = 2,
  autostart = true,
  callback  = function()
    local focused = awful.screen.focused()
    focused.brightness_osd_container.visible = false
  end
}

local function brightness_osd_rerun()
  if hide_osd.started then
    hide_osd:again()
  else
    hide_osd:start()
  end
end

update_brightness()


local osd_margin = dpi(40)

local placement_placer = function()
  local focused = awful.screen.focused()
  awful.placement.bottom(
    focused.brightness_osd_container,
    {
      margins = {
        left = 0,
        right = 0,
        top = 0,
        bottom = osd_margin
      },
      honor_workarea = true
    }

  )
end

awesome.connect_signal(
  'module::brightness_osd:show',
  function(bool)
    placement_placer()
    update_brightness()
    awful.screen.focused().brightness_osd_container.visible = bool
    if bool then
      brightness_osd_rerun()
      if awful.screen.focused().volume_osd_container.visible then
        awful.screen.focused().volume_osd_container.visible = false
      end
    else
      if hide_osd.started then
        hide_osd:stop()
      end
    end
  end
)

local osd_height = dpi(50)
local osd_width = dpi(200)


local function setup_brightness_osd(s)
  local s = s or {}

  -- Create the box
  s.brightness_osd_container = awful.popup {
    widget = {
      -- Removing this block will cause an error...
    },
    ontop = true,
    visible = false,
    type = 'notification',
    screen = s,
    height = osd_height,
    width = osd_width,
    maximum_height = osd_height,
    maximum_width = osd_width,
    offset = 5,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 50)
    end,
    bg = beautiful.transparent,
    preferred_anchors = 'middle',
    preferred_positions = { 'left', 'right', 'top', 'bottom' }
  }

  s.brightness_osd_container:setup {

    layout = wibox.layout.align.horizontal,
    icon,
    {
      widget = wibox.container.margin,
      left = dpi(10),
      right = dpi(15),
      brightness_slider
    }
  }

  s.brightness_osd_container:connect_signal(
    'mouse::enter',
    function()
      hide_osd:stop()
    end
  )
  s.brightness_osd_container:connect_signal(
    'mouse::leave',
    function()
      brightness_osd_rerun()
    end
  )
end


-- mouse::leave


return {
  setup_brightness_osd = setup_brightness_osd
}
