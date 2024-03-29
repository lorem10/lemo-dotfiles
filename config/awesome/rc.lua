pcall(require, "luarocks.loader")
local beautiful = require("beautiful")
local gears = require("gears")

local brightness_osd = require("components.brightness_osd")
local filesystem = gears.filesystem

local theme_dir = filesystem.get_configuration_dir() .. '/theme'
beautiful.init(theme_dir .. "/theme.lua")

require("signals")
local wibar = require("components.wibar")
local globalkeys = require("keys.global")
-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local volume = require("components.volume-osd")
-- Theme handling library
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Get the width & height of the screen

-- Print the width to the console
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {awful.layout.suit.floating, awful.layout.suit.tile, awful.layout.suit.tile.left,
                        awful.layout.suit.tile.bottom, awful.layout.suit.tile.top, awful.layout.suit.fair,
                        awful.layout.suit.fair.horizontal, awful.layout.suit.spiral, awful.layout.suit.spiral.dwindle,
                        awful.layout.suit.max, awful.layout.suit.max.fullscreen, awful.layout.suit.magnifier,
                        awful.layout.suit.corner.nw, awful.layout.suit.corner.ne, awful.layout.suit.corner.sw,
                        awful.layout.suit.corner.se}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {{"hotkeys", function()
    hotkeys_popup.show_help(nil, awful.screen.focused())
end}, {"manual", terminal .. " -e man awesome"}, {"edit config", editor_cmd .. " " .. awesome.conffile},
                 {"restart", awesome.restart}, {"quit", function()
    awesome.quit()
end}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher

-- {{{ Wibar
-- Create a textclock widget

-- Create a wibox for each screen and add it

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    wibar.setup_wibar(s)
    -- Wallpaper
    set_wallpaper(s)
    volume.setup_volume_osd(s)
    brightness_osd.setup_brightness_osd(s)
    -- Each screen has its own tag table.
    awful.tag({"1", "2", "3", "4", "5", "6", "7", "8"}, s, awful.layout.layouts[8])
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.

    -- Create a taglist widget

    -- Create a tasklist widget
    -- Create the wibox

    -- Add widgets to the wibox
    -- s.mywibox:setup {
    --     layout = wibox.layout.align.horizontal,
    --     { -- Left widgets
    --         layout = wibox.layout.fixed.horizontal,
    --         mylauncher,
    --         s.mytaglist,
    --         s.mypromptbox,
    --     },
    --     s.mytasklist, -- Middle widget
    --     {             -- Right widgets
    --         layout = wibox.layout.fixed.horizontal,
    --         mykeyboardlayout,
    --         wibox.widget.systray(),
    --         mytextclock,
    --         s.mylayoutbox,
    --     },
    -- }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(awful.button({}, 3, function()
    mymainmenu:toggle()
end), awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev)))
-- }}}

-- {{{ Key bindings

clientkeys = gears.table.join(awful.key({modkey}, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
end, {
    description = "toggle fullscreen",
    group = "client"
}), awful.key({modkey, "Shift"}, "c", function(c)
    c:kill()
end, {
    description = "close",
    group = "client"
}), awful.key({modkey, "Control"}, "space", awful.client.floating.toggle, {
    description = "toggle floating",
    group = "client"
}), awful.key({modkey, "Control"}, "Return", function(c)
    c:swap(awful.client.getmaster())
end, {
    description = "move to master",
    group = "client"
}), awful.key({modkey}, "o", function(c)
    c:move_to_screen()
end, {
    description = "move to screen",
    group = "client"
}), awful.key({modkey}, "t", function(c)
    c.ontop = not c.ontop
end, {
    description = "toggle keep on top",
    group = "client"
}), awful.key({modkey}, "n", function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
end, {
    description = "minimize",
    group = "client"
}), awful.key({modkey}, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
end, {
    description = "(un)maximize",
    group = "client"
}), awful.key({modkey, "Control"}, "m", function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
end, {
    description = "(un)maximize vertically",
    group = "client"
}), awful.key({modkey, "Shift"}, "m", function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
end, {
    description = "(un)maximize horizontally",
    group = "client"
}))

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys, -- View tag only.
    awful.key({modkey}, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            tag:view_only()
        end
    end, {
        description = "view tag #" .. i,
        group = "tag"
    }), -- Toggle tag display.
    awful.key({modkey, "Control"}, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end, {
        description = "toggle tag #" .. i,
        group = "tag"
    }), -- Move client to tag.
    awful.key({modkey, "Shift"}, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end, {
        description = "move focused client to tag #" .. i,
        group = "tag"
    }), -- Toggle tag on focused client.
    awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        end
    end, {
        description = "toggle focused client on tag #" .. i,
        group = "tag"
    }))
end

clientbuttons = gears.table.join(awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", {
        raise = true
    })
end), awful.button({modkey}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", {
        raise = true
    })
    awful.mouse.client.move(c)
end), awful.button({modkey}, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", {
        raise = true
    })
    awful.mouse.client.resize(c)
end))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = { -- All clients will match this rule.
{
    rule = {},
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
}, -- Floating clients.
{
    rule_any = {
        instance = {"DTA", -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry"},
        class = {"Arandr", "Blueman-manager", "Gpick", "Kruler", "MessageWin", -- kalarm.
        "Sxiv", "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui", "veromix", "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {"Event Tester" -- xev.
        },
        role = {"AlarmWindow", -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
        }
    },
    properties = {
        floating = true
    }
}, -- Add titlebars to normal clients and dialogs
{
    rule_any = {
        type = {"normal", "dialog"}
    },
    properties = {
        titlebars_enabled = true
    }
}, -- Set Firefox to always map on the tag named "2" on screen 1.
{
    rule = {
        class = "Firefox"
    },
    properties = {
        screen = 1,
        tag = "3"
    }
}, {
    rule = {
        class = "Google-chrome"
    },
    properties = {
        screen = 1,
        tag = "3"
    }
}, {
    rule = {
        class = "rofi"
    },
    properties = {
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10) -- Adjust the radius as needed
        end
    }
}, {
    rule = {
        class = "Code"
    },
    properties = {
        screen = 1,
        tag = "2"
    }
}, {
    rule = {
        class = "nekoray"
    },
    properties = {
        screen = 1,
        tag = "8"
    }
}, {
    rule = {
        class = "Spotify"
    },
    properties = {
        screen = 1,
        tag = "7"
    }
}, {
    rule = {
        class = "Telegram"
    },
    properties = {
        screen = 1,
        tag = "6"
    }
}}
-- }}}

client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(awful.button({}, 1, function()
        c:emit_signal("request::activate", "titlebar", {
            raise = true
        })
        awful.mouse.client.move(c)
    end), awful.button({}, 3, function()
        c:emit_signal("request::activate", "titlebar", {
            raise = true
        })
        awful.mouse.client.resize(c)
    end))

    awful.titlebar(c, {
        size = dpi(35),
        bg_normal = '#000000',
        bg_focus = '#000000dd',
        position = "top"
    }):setup{
        { -- Left
            bottons = bottons,
            {
                margins = 8,
                widget = wibox.container.margin,
                awful.titlebar.widget.stickybutton(c),
            },
            {
                margins = 8,
                widget = wibox.container.margin,
                awful.titlebar.widget.ontopbutton(c),
            },
            {
                margins = 8,
                widget = wibox.container.margin,
                awful.titlebar.widget.floatingbutton(c)
            },
            layout = wibox.layout.fixed.horizontal()
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Right
            widget = wibox.container.margin,
            right = 4,
            {

                {
                    margins = 8,
                    widget = wibox.container.margin,
                    awful.titlebar.widget.minimizebutton(c)

                },
                {
                    margins = 8,
                    widget = wibox.container.margin,
                    awful.titlebar.widget.maximizedbutton(c)

                },
                {
                    margins = 8,
                    widget = wibox.container.margin,
                    awful.titlebar.widget.closebutton(c)
                },
                layout = wibox.layout.fixed.horizontal
            }

        },
        layout = wibox.layout.align.horizontal
    }
end)

beautiful.notification_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 5)
end

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- run picom
awful.spawn.with_shell("picom --config ~/.config/picom/picom.conf --experimental-backends &")
-- }}}
