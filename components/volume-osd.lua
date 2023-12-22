-- local wibox = require("wibox")
-- local awful = require("awful")
-- local gears = require('gears')
-- local beautiful = require('beautiful')

-- local slider_osd = wibox.widget {
--   nil,
--   {
--     id = 'vol_osd_slider',
--     bar_shape = gears.shape.rounded_rect,
--     bar_height = 2,
--     bar_color = '#ffffff20',
--     hide_on_right_click = true,
--     bar_active_color = '#f2f2f2EE',
--     handle_color = '#ffffff',
--     handle_shape = gears.shape.circle,
--     handle_width = 15,
--     handle_border_color = '#00000012',
--     handle_border_width = 1,
--     maximum = 100,
--     widget = wibox.widget.slider
--   },
--   nil,
--   expand = 'none',
--   layout = wibox.layout.align.vertical
-- }

-- local volume_slider_osd = wibox.widget {
--   slider_osd,
--   spacing = 24,
--   layout = wibox.layout.fixed.horizontal
-- }

-- local osd_value = wibox.widget {
--   text = '0%',
--   font = 'Inter Bold 12',
--   align = 'center',
--   valign = 'center',
--   widget = wibox.widget.textbox
-- }

-- local vol_osd_slider = slider_osd.vol_osd_slider

-- vol_osd_slider:connect_signal(
--   'property::value',
--   function()
--     local volume_level = vol_osd_slider:get_value()
--     awful.spawn('amixer -D pulse sset Master ' .. volume_level .. '%', false)

--     -- Update textbox widget text
--     osd_value.text = volume_level .. '%'

--     -- Update the volume slider if values here change
--     awesome.emit_signal('widget::volume:update', volume_level)

--     if awful.screen.focused().show_vol_osd then
--       awesome.emit_signal(
--         'module::volume_osd:show',
--         true
--       )
--     end
--   end
-- )

-- local osd_height = 100
-- local osd_width = 300
-- local osd_margin = 10

-- local hide_osd = gears.timer {
--   timeout   = 2,
--   autostart = true,
--   callback  = function()
--     local focused = awful.screen.focused()
--     focused.volume_osd.visible = false
--   end
-- }
-- local function setup_volume(s)
--   s.volume_osd = awful.popup {
--     widget = {
--       -- Removing this block will cause an error...
--     },
--     ontop = true,
--     visible = false,
--     type = 'notification',
--     screen = s,
--     height = osd_height,
--     width = osd_width,
--     maximum_height = osd_height,
--     maximum_width = osd_width,
--     offset = 5,
--     shape = gears.shape.rectangle,
--     bg = beautiful.transparent,
--     preferred_anchors = 'middle',
--     preferred_positions = { 'left', 'right', 'top', 'bottom' }
--   }


--   s.volume_osd:setup {
--     {
--       {
--         {
--           layout = wibox.layout.align.horizontal,
--           expand = 'none',
--           forced_height = 48,
--           nil,
--         },
--         volume_slider_osd,
--         layout = wibox.layout.fixed.vertical
--       },
--       left = 24,
--       right = 24,
--       widget = wibox.container.margin
--     },
--     bg = beautiful.background,
--     shape = gears.shape.rounded_rect,
--     widget = wibox.container.background()
--   }
-- end

-- awesome.connect_signal(
--   'module::volume_osd:rerun',
--   function()
--     if hide_osd.started then
--       hide_osd:again()
--     else
--       hide_osd:start()
--     end
--   end
-- )

-- awesome.connect_signal(
--   'module::volume_osd:show',
--   function(bool)
--     awful.screen.focused().volume_osd.visible = bool
--     awesome.emit_signal('module::volume_osd:rerun')
--   end
-- )

-- return {
--   setup_volume = setup_volume
-- }
