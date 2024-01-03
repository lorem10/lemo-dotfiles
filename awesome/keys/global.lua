---------------------------
-- Lemo awesome keys --
---------------------------


local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")


modkey = "Mod4"


local globalkeys = gears.table.join(

-- screenshot
    awful.key({}, "Print", function()
        awful.spawn.with_shell("scrot -e 'xclip -selection clipboard -t image/png -i $f'")
    end),
    awful.key(
        { modkey, },
        "s",
        hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }
    ),
    awful.key(
        { modkey, "Control" },
        "j",
        awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),
    awful.key(
        { modkey, "Control" },
        "k",
        awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),
    awful.key(
        { modkey, },
        "Escape",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),

    -- move focused client to next/previous tag and view tag
    awful.key(
        { modkey, 'Control', "Shift" },
        "k",
        function()
            local screen = awful.screen.focused()
            local t = screen.selected_tag
            if t then
                local idx = t.index + 1
                if idx > #screen.tags then idx = 1 end
                if client.focus then
                    client.focus:move_to_tag(screen.tags[idx])
                    screen.tags[idx]:view_only()
                end
            end
        end,
        { description = "move focused client to next tag and view tag", group = "tag" }
    ),
    awful.key({ modkey, 'Control', "Shift" }, "j", function()
            local screen = awful.screen.focused()
            local t = screen.selected_tag
            if t then
                local idx = t.index - 1
                if idx == 0 then idx = #screen.tags end
                if client.focus then
                    client.focus:move_to_tag(screen.tags[idx])
                    screen.tags[idx]:view_only()
                end
            end
        end,
        { description = "move focused client to previous tag and view tag", group = "tag" }),

    awful.key(
        { modkey, },
        "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key(
        { modkey, },
        "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key(
        { modkey, },
        "w",
        function() mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }
    ),

    -- Layout manipulation
    awful.key(
        { modkey, "Shift" },
        "j",
        function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }
    ),
    awful.key(
        { modkey, "Shift" },
        "k",
        function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }
    ),
    awful.key(
        { modkey, "Control" },
        "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }
    ),
    awful.key(
        { modkey, "Control" },
        "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }
    ),
    awful.key(
        { modkey, },
        "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),
    awful.key(
        { modkey, },
        "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }
    ),

    -- volume control
    awful.key(
        {},
        'XF86AudioRaiseVolume',
        function()
            awful.spawn('amixer -D pulse sset Master 5%+', false)
            awesome.emit_signal('widget::volume:update')
            awesome.emit_signal("module::volume_osd:show", true)
        end,
        { description = 'increase volume up by 5%', group = 'hotkeys' }
    ),
    awful.key(
        {},
        'XF86AudioLowerVolume',
        function()
            awful.spawn('amixer -D pulse sset Master 5%-', false)
            awesome.emit_signal('widget::volume:update')
            awesome.emit_signal("module::volume_osd:show", true)
        end,
        { description = 'decrease volume up by 5%', group = 'hotkeys' }
    ),
    awful.key(
        {},
        'XF86AudioMute',
        function()
            awful.spawn('amixer -D pulse set Master 1+ toggle', false)
            awesome.emit_signal('widget::volume:update')
            awesome.emit_signal("module::volume_osd:show", true)
        end,
        { description = 'toggle mute', group = 'hotkeys' }
    ),
    -- brightness
    awful.key(
        {},
        'XF86MonBrightnessUp',
        function()
            awful.spawn('brightnessctl set 35+', false)
            awesome.emit_signal('widget::brightness:update')
            awesome.emit_signal("module::brightness_osd:show", true)

        end,
        { description = 'increase brightness by 10%', group = 'hotkeys' }
    ),
    awful.key(
        {},
        'XF86MonBrightnessDown',
        function()
            awful.spawn('brightnessctl set 35-', false)
            awesome.emit_signal('widget::brightness:update')
            awesome.emit_signal("module::brightness_osd:show", true)
        end,
        { description = 'decrease brightness by 10%', group = 'hotkeys' }
    ),
    -- Standard program
    awful.key(
        { modkey, },
        "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }
    ),
    awful.key(
        { modkey, "Control" },
        "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),
    awful.key(
        { modkey, "Shift" },
        "q",
        awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),
    awful.key(
        { modkey, },
        "l",
        function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }
    ),
    awful.key(
        { modkey, },
        "h",
        function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }
    ),
    awful.key(
        { modkey, "Shift" },
        "h",
        function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }
    ),
    awful.key(
        { modkey, "Shift" },
        "l",
        function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }
    ),
    awful.key(
        { modkey, "Control" },
        "h",
        function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }
    ),
    awful.key(
        { modkey, "Control" },
        "l",
        function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }
    ),
    awful.key(
        { modkey, },
        "space",
        function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }
    ),
    awful.key(
        { modkey, "Shift" },
        "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }
    ),

    awful.key(
        { modkey, "Control" },
        "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }
    ),

    -- Prompt
    awful.key(
        { modkey },
        "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }
    ),

    awful.key(
        { modkey },
        "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }
    ),
    -- Menubar
    awful.key(
        { modkey },
        "p",
        function() awful.spawn.with_shell("rofi -show drun -theme $HOME/.config/rofi/launcher") end,
        { description = "show the menubar", group = "launcher" }
    )
)

return globalkeys
