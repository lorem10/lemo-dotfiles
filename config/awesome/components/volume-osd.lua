local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local xresources          = require("beautiful.xresources")
local dpi                 = xresources.apply_dpi



local filesystem = gears.filesystem
local theme_dir  = filesystem.get_configuration_dir() .. '/theme'


local percentText = wibox.widget {
  margins = 0,
  widget = wibox.container.margin,
  {
    forced_width = dpi(70),
    widget = wibox.widget.textbox,
  }
}

local volume_slider = wibox.widget {
  widget              = wibox.widget.slider,
  bar_shape           = gears.shape.rounded_rect,
  bar_height          = dpi(3),
  bar_color           = "#aaa",
  handle_color        = "#fff",
  handle_shape        = gears.shape.circle,
  handle_border_color = beautiful.border_color,
  handle_border_width = 0,
  handle_width        = dpi(15),
  value               = 70,
}


local icon = wibox.widget {
  widget = wibox.container.margin,
  top = dpi(10),
  left = dpi(10),
  bottom = dpi(10),
  {
    resize = true,
    -- forced_width = 100,
    widget = wibox.widget.imagebox,
    image = theme_dir .. "/icons/volume-up.svg"
  },
}
local update_volume = function()
  awful.spawn.easy_async_with_shell(
    [[sleep 0.1;bash -c "amixer -D pulse sget Master"]],
    function(stdout)
      local volume = string.match(stdout, '(%d?%d?%d)%%')
      local isMuted = string.match(stdout, '%[off%]')
      if isMuted then
        icon.widget.image = theme_dir .. "/icons/volume-x.svg"
        percentText.widget:set_markup_silently("Mute")
        -- volume_slider.value = 0
      else
        volume_slider.value = tonumber(volume)
        icon.widget.image = theme_dir .. "/icons/volume-up.svg"
        percentText.widget:set_markup_silently(tonumber(volume) .. '%')
      end
    end
  )
end

icon:connect_signal(
  'button::press',
  function()
    awful.spawn('amixer -D pulse set Master 1+ toggle', false)
    update_volume()
    awesome.emit_signal('widget::volume:update')
  end
)



volume_slider:connect_signal(
  'property::value',
  function()
    local volume_level = volume_slider:get_value()
    awful.spawn('amixer -D pulse sset Master ' .. volume_level .. '%', false)

    -- Update textbox widget text
    -- osd_value.text = volume_level .. '%'

    -- Update the volume slider if values here change
    awesome.emit_signal('widget::volume:update', volume_level)

    -- if awful.screen.focused().show_vol_osd then
    --   awesome.emit_signal(
    --     'module::volume_osd:show',
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
    focused.volume_osd_container.visible = false
  end
}

local function volume_osd_rerun()
  if hide_osd.started then
    hide_osd:again()
  else
    hide_osd:start()
  end
end

update_volume()


local osd_margin = dpi(40)

local placement_placer = function()
  local focused = awful.screen.focused()
  awful.placement.bottom(
    focused.volume_osd_container,
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
  'module::volume_osd:show',
  function(bool)
    placement_placer()
    update_volume()
    awful.screen.focused().volume_osd_container.visible = bool
    if bool then
      volume_osd_rerun()
      if awful.screen.focused().brightness_osd_container.visible then
        awful.screen.focused().brightness_osd_container.visible = false
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


local function setup_volume_osd(s)
  local s = s or {}

  -- Create the box
  s.volume_osd_container = awful.popup {
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

  s.volume_osd_container:setup {

    layout = wibox.layout.align.horizontal,
    icon,
    {
      widget = wibox.container.margin,
      left = dpi(10),
      right = dpi(15),
      volume_slider
    }
  }

  s.volume_osd_container:connect_signal(
    'mouse::enter',
    function()
      hide_osd:stop()
    end
  )
  s.volume_osd_container:connect_signal(
    'mouse::leave',
    function()
      volume_osd_rerun()
    end
  )
end


-- mouse::leave


return {
  setup_volume_osd = setup_volume_osd
}
