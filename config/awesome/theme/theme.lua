---------------------------
-- Lemo awesome theme --
---------------------------


local gears               = require("gears")
local naughty             = require("naughty")

local filesystem          = gears.filesystem

local theme_dir           = filesystem.get_configuration_dir() .. '/theme'

local theme_assets        = require("beautiful.theme_assets")
local xresources          = require("beautiful.xresources")
local dpi                 = xresources.apply_dpi

local default_themes_path = filesystem.get_themes_dir()

local theme               = {}

-- h1 { font-size: 24px; }
-- h2 { font-size: 19.0488px; }
-- h3 { font-size: 15.1191px; }
-- p { font-size: 12px; }
-- small { font-size: 9.5244px; }
theme.font                 = "Lato 12"

theme.bg_normal            = "#000000BD"
theme.bg_focus             = "#ffffff90"
theme.bg_urgent            = "#f7672a"
theme.bg_minimize          = "#00000080"
theme.bg_systray           = "#00000000"
theme.systray_icon_spacing = dpi(15)

theme.fg_normal            = "#aaaaaa"
theme.fg_focus             = "#ffffff"
theme.fg_urgent            = "#ffffff"
theme.fg_minimize          = "#ffffff"

theme.useless_gap          = dpi(5)
theme.gap_single_client    = false
theme.border_width         = dpi(0)
theme.border_normal        = "#000000"
theme.border_focus         = "#535d6c"
theme.border_marked        = "#91231c"


theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_bg_focus = theme.bg_normal
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)


-- config notifications
theme.notification_margin               = dpi(10)
theme.notification_font                 = theme.font
theme.notification_border_width         = 0
theme.notification_position             = 'top_right'
theme.notification_icon_size            = dpi(100)
theme.notification_icon_resize_strategy = 'center'
theme.notification_spacing              = dpi(10)
theme.notification_border_color         = "#00000000"
theme.notification_max_width            = dpi(480)
theme.notification_width                = dpi(350)
theme.notification_shape                = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 5)
end

naughty.config.defaults.margin          = theme.notification_margin
naughty.config.defaults.spacing         = theme.notification_spacing
naughty.config.defaults.position        = theme.notification_position

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon                 = default_themes_path .. "default/submenu.png"
theme.menu_height                       = dpi(15)
theme.menu_width                        = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

theme.wallpaper                         = theme_dir .. "/wallpaper/8.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh                      = default_themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv                      = default_themes_path .. "default/layouts/fairvw.png"
theme.layout_floating                   = default_themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier                  = default_themes_path .. "default/layouts/magnifierw.png"
theme.layout_max                        = default_themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen                 = default_themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom                 = default_themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft                   = default_themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile                       = default_themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop                    = default_themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral                     = default_themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle                    = default_themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw                   = default_themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne                   = default_themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw                   = default_themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse                   = default_themes_path .. "default/layouts/cornersew.png"

-- Generate Awesome icon:
-- theme.awesome_icon = theme_assets.awesome_icon(
--     theme.menu_height, theme.bg_focus, theme.fg_focus
-- )

theme.awesome_icon                      = theme_dir .. "/icons/launcher.svg"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme                        = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
