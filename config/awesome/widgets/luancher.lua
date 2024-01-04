local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local mylauncher = wibox.widget {
    image = beautiful.awesome_icon,
    resize = false,
    widget = wibox.widget.imagebox
}

mylauncher:connect_signal("button::press", function()
    awful.spawn.with_shell("rofi -show drun -theme $HOME/.config/rofi/launcher")
end)

return mylauncher
