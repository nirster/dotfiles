theme = {}

arch = os.getenv("HOME") .. "/.config/awesome/themes/arch"

--Fonts

theme.font          = "Inconsolata 11"
theme.font_mono     = "Inconsolata 11"

--Colors

theme.bg_normal     = "#222222"
theme.bg_focus      = "#1793d0"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#1793d0"
theme.fg_focus      = "#222222"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

--Border

theme.border_width  = 2
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = arch .. "/taglist/squarefw.png"
theme.taglist_squares_unsel = arch .. "/taglist/squarew.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = arch .. "/submenu.png"
theme.menu_height = 15
theme.menu_width  = 150

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = arch .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = arch .. "/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = arch .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = arch .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = arch .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = arch .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = arch .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = arch .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = arch .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = arch .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = arch .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = arch .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = arch .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = arch .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = arch .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = arch .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = arch .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = arch .. "/titlebar/maximized_focus_active.png"

--Wallpaper
theme.wallpaper_cmd = { "nitrogen --restore" }
--theme.wallpaper =
--arch .. "/background.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = arch .. "/layouts/fairhw.png"
theme.layout_fairv = arch .. "/layouts/fairvw.png"
theme.layout_floating  = arch .. "/layouts/floatingw.png"
--theme.layout_magnifier = arch .. "/layouts/magnifierw.png"
--theme.layout_max = arch .. "/layouts/maxw.png"
--theme.layout_fullscreen = arch .. "/layouts/fullscreenw.png"
theme.layout_tilebottom = arch .. "/layouts/tilebottomw.png"
theme.layout_tileleft   = arch .. "/layouts/tileleftw.png"
theme.layout_tile = arch .. "/layouts/tilew.png"
theme.layout_tiletop = arch .. "/layouts/tiletopw.png"
theme.layout_spiral  = arch .. "/layouts/spiralw.png"
--theme.layout_dwindle = arch .. "/layouts/dwindlew.png"

--theme.awesome_icon = arch ..  "/icons/awesome16.png"
theme.awesome_icon = arch ..  "/icons/starthere.png"
-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
