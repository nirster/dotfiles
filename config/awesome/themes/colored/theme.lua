------------------------------------------------
--         Full Color Awesome Theme           --    
--          by TheImmortalPhoenix             --
-- http://theimmortalphoenix.deviantart.com/  --
------------------------------------------------

-- {{{ Main

theme           = {}
theme.config    = os.getenv("HOME") .. "/.config/awesome/themes/colored"
theme.layouts   = theme.config .. "/layouts/blue"
theme.icons     = os.getenv("HOME") .. "/.config/awesome/icons"

-- }}}
-- {{{ Font

--theme.font  =  "Termsyn 18"
theme.font      =       "Terminus (TTF) for Powerline 12"
theme.notify_font =     "Terminus (TTF) for Powerline 14"


-- }}}
-- {{{ Colors

theme.fg_grey           =  "#424242"
theme.fg_black          =  "#080808"
theme.fg_red            =  "#ce5666"
theme.fg_green          =  "#80a673"
theme.fg_yellow         =  "#ffaf5f"
theme.fg_blue           =  "#778baf"
theme.fg_magenta        =  "#94738c"
theme.fg_cyan           =  "#69b2b2"
theme.fg_white          =  "#aaaaaa"

theme.bg_normal         =  theme.fg_black
theme.bg_focus          =  theme.fg_black
theme.bg_urgent         =  theme.fg_black
theme.bg_minimize       =  theme.fg_black
 
theme.fg_normal         =  theme.fg_white
theme.fg_focus          =  theme.fg_blue
theme.fg_urgent         =  theme.fg_red
theme.fg_minimize       =  theme.fg_grey

theme.tasklist_fg_focus =  theme.fg_blue
theme.bg_systray        =  theme.fg_black

-- }}}
-- {{{ Borders

theme.border_width   =  2
theme.border_normal  =  "#202020"
theme.border_focus   =  "#535d6c"
theme.border_tooltip =  "#404040"

-- }}}
-- {{{ Menu

theme.menu_height       = "20"
theme.menu_width        = "150"
theme.menu_border_width = "1"
theme.menu_fg_focus     = theme.fg_green
theme.menu_bg_focus     = theme.fg_black

-- }}}
-- {{{ Titlebars

theme.titlebar_bg_focus  =  theme.fg_black
theme.titlebar_bg_normal =  theme.fg_black
theme.titlebar_fg_focus  =  theme.fg_red
theme.titlebar_fg_normal =  theme.fg_grey

-- }}}
-- {{{ Icons
-- {{{  Widget Icons

theme.widget_uptime     = theme.icons .. "/yellow/ac_01.png"
theme.widget_cpu        = theme.icons .. "/green/cpu.png"
theme.widget_temp       = theme.icons .. "/yellow/temp.png"
theme.widget_mem        = theme.icons .. "/blue/mem.png"
theme.widget_fs         = theme.icons .. "/green/usb.png"
theme.widget_netdown    = theme.icons .. "/green/net_down_03.png"
theme.widget_netup      = theme.icons .. "/red/net_up_03.png"
theme.widget_mail       = theme.icons .. "/yellow/mail.png"
theme.widget_sys        = theme.icons .. "/magenta/arch.png"
theme.widget_pac        = theme.icons .. "/magenta/pacman.png"
theme.widget_batt       = theme.icons .. "/yellow/bat_full_01.png"
theme.widget_clock      = theme.icons .. "/blue/clock.png"
theme.widget_vol        = theme.icons .. "/red/spkr_01.png"
theme.widget_mpd        = theme.icons .. "/red/note.png"

-- }}}
-- {{{ Taglist

theme.taglist_squares_sel   = theme.config .. "/taglist/squaref_b.png"
theme.taglist_squares_unsel = theme.config .. "/taglist/square_b.png"

--theme.taglist_squares_resize = "false"

-- }}}
-- {{{ Titlebar

theme.titlebar_close_button_focus               =   theme.config .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal              =   theme.config .. "/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active        =   theme.config .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       =   theme.config .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      =   theme.config .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     =   theme.config .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active       =   theme.config .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      =   theme.config .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     =   theme.config .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    =   theme.config .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active     =   theme.config .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    =   theme.config .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   =   theme.config .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  =   theme.config .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active    =   theme.config .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   =   theme.config .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  =   theme.config .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive =   theme.config .. "/titlebar/maximized_normal_inactive.png"

-- }}}
-- {{{ Misc

theme.tasklist_floating             =   "[float] "
theme.tasklist_maximized_vertical   =   "[max] "
theme.tasklist_sticky               =   "[sticky] "
theme.tasklist_ontop                =   "[ontop] "

-- }}}
-- {{{ Layouts

theme.layout_floating       =   theme.layouts .. "/floating.png"
theme.layout_tile           =   theme.layouts .. "/tile.png"
theme.layout_tilebottom     =   theme.layouts .. "/tilebottom.png"
theme.layout_fairv          =   theme.layouts .. "/fairv.png"
theme.layout_fairh          =   theme.layouts .. "/fairh.png"

-- theme.layout_floating       =   "[float]"
-- theme.layout_tile           =   "[tile]"
-- theme.layout_tilebottom     =   "[tileB]"
-- theme.layout_fairv          =   "[fair]"
-- theme.layout_fairh          =   "[fairH]"

-- }}}
-- }}}

return theme
