local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local volume = require("widgets.volume")
local battery = require("widgets.battery")
local systray_container = require("widgets.systray")
local brightness = require("widgets.brightness")
local mylauncher = require("widgets.luancher")
local mytasklist = require("widgets.tasklist")
local mytaglist = require("widgets.taglist")
local screen_geometry = awful.screen.focused().geometry
local screen_width = screen_geometry.width
local screen_height = screen_geometry.height

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

mykeyboardlayout = awful.widget.keyboardlayout()
mytextclock = wibox.widget.textclock()

local function setup_wibar(s)
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(awful.button({}, 1, function()
        awful.layout.inc(1)
    end), awful.button({}, 3, function()
        awful.layout.inc(-1)
    end), awful.button({}, 4, function()
        awful.layout.inc(1)
    end), awful.button({}, 5, function()
        awful.layout.inc(-1)
    end)))

    s.mywibox = awful.wibar({
        position = "bottom",
        screen = s,
        height = dpi(50),
    })
    s.centerwibox = wibox({
        ontop = false,
        screen = s,
        bg = "#ffffff00",
        height = dpi(14),
        width = dpi(266),
        type = "desktop",
        visible = true,
        y = screen_height - ((s.mywibox.height / 2) + 7),
        x = (screen_width / 2 - (dpi(266) / 2)),

        position = "bottom"
    })

    s.border_top = awful.wibar({
        position = "bottom",
        screen = s,
        height = 1,
        bg = "#ffffff20"
    })

    s.mywibox:setup{
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    top = dpi(12),
                    bottom = dpi(12),
                    right = dpi(20),
                    left = dpi(12),
                    mylauncher
                },
                {

                    widget = wibox.container.margin,
                    top = dpi(7),
                    mytasklist.setup_tasklist(s)
                }
            }
        },
        { -- center
            layout = wibox.layout.fixed.horizontal,
            {
                widget = wibox.container.margin,
                margins = dpi(12)
            }
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            {
                widget = wibox.container.margin,
                margins = dpi(12),
                systray_container
            },
            {
                widget = wibox.container.margin,
                margins = dpi(12),
                volume
            },
            {
                widget = wibox.container.margin,
                margins = dpi(12),
                brightness
            },
            {
                widget = wibox.container.margin,
                margins = dpi(12),
                battery
            },
            mykeyboardlayout,
            {
                widget = wibox.container.margin,
                margins = dpi(12),
                mytextclock
            },

            {
                widget = wibox.container.margin,
                margins = dpi(12),
                s.mylayoutbox
            }
        }
    }
    s.centerwibox:setup{
        layout = wibox.layout.align.horizontal,
        nill,
        mytaglist.setup_taglist(s),
        nill
    }
end

return {
    setup_wibar = setup_wibar
}
