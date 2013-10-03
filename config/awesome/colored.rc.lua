-- vim: set tabstop=2 shiftwidth=2 softtabstop=2
-- {{{ Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local scratch = require("scratch")
local myplacesmenu = require("myplacesmenu")
local blingbling = require("blingbling")
local wi = require("wi")
require("revelation")

--  Error handling
if awesome.startup_errors then
        naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
        local in_error = false
        awesome.connect_signal("debug::error", function (err)
                -- Make sure we don't go into an endless error loop
                if in_error then return end
                in_error = true

                naughty.notify({ preset = naughty.config.presets.critical,
                title = "Oops, an error happened!",
                text = err })
                in_error = false
        end)
end
-- }}} 
-- {{{ Startup and theme
function run_once(cmd)
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
                findme = cmd:sub(0, firstspace-1)
        end
        awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end 
--run_once("dropboxd")
run_once("start-pulseaudio-x11")
--run_once("nitrogen --restore")
--run_once("xrdb -merge ~/.Xresources")
beautiful.init("/home/nir/.config/awesome/themes/colored/theme.lua")
-- }}}
--  {{{ Variables
terminal = "urxvtc"
terminale = terminal .. " -name Terminal -title Terminal "
root_terminal    = " sudo " .. terminal .. " -title 'Root Terminal' "
small_terminal = terminal .. " -title 'Small Terminal' -geometry 60x10 "
editor = "vim" 
editor_cmd = terminal .. " -e " .. editor
calc = "gnome-calculator"
browser = "google-chrome --audio-buffer-size=4096"
mail = "google-chrome --audio-buffer-size=4096 www.gmail.com"
scripts          = " sh ~/.config/awesome/scripts "
fileman = "thunar"
filemancli = "urxvtc -name Ranger -title Ranger -e ranger"
local barheight = 30
-- keys
modkey = "Mod4"
altkey = "Mod1"
control= "Control"
shift  = "Shift"

scripts          = " sh ~/.config/awesome/scripts/ "
exec   = awful.util.spawn
execs  = awful.util.spawn_with_shell
cli_fileman      = terminal .. " -title 'File Manager' -e ranger "
cli_root_fileman = terminal .. " -title 'Root File Manager' -e sudo ranger " 
music            = terminal .. " -geometry 199x57 -title Music -e ncmpcpp "
musica           = terminal .. " -title Music "
musicinfo        = terminal .. " -title MusicInfo -e lyvi "
chat             = terminal .. " -title Chat -e " .. scripts .. "weechat"
torrent          = terminal .. " -title Torrent -e " .. scripts .. "torrent"
tasks            = terminal .. " -title Tasks -e sudo htop "
powertop         = terminal .. " -title Powertop -e sudo powertop "
update           = terminal .. " -title Updating -e yaourt -Syua --noconfirm "
feed             = terminal .. " -title Feed -e newsbeuter " 
mixer            = terminal .. " -title Mixer -e alsamixer " 
youtube          = terminal .. " -title Youtube -e youtube-viewer -m -C "
local cmd =
{
        lock = "xscreensaver-command --lock",
        play  = "sh /home/nir/scripts/cplay",
        skip  = "cmus-remote --next",
        prev  = "cmus-remote --prev",
        stop  = "cmus-remote --stop",
        volup = "amixer -q -c 0 set Master 3+ unmute",
        voldn = "amixer -q -c 0 set Master 3- unmute",
        mute  = "amixer -q  set Master toggle",
        mixer = terminal .. " -e alsamixer"
}
-- }}}
--  {{{ Layouts
local layouts =
{
        awful.layout.suit.tile,        --1
        awful.layout.suit.tile.right,  --2
        awful.layout.suit.tile.bottom, --3
        awful.layout.suit.tile.top,    --4
        awful.layout.suit.floating     --5
}
-- }}}
-- {{{ Wallpaper
if beautiful.wallpaper then
        for s = 1, screen.count() do
                gears.wallpaper.maximized(beautiful.wallpaper, s, true)
        end
end
-- }}}
-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
        names = { "web", "term", "code", "files", "docs", "media" },
        layout = { layouts[1], layouts[2], layouts[4], layouts[1], layouts[4], layouts[1] }
}
for s = 1, screen.count() do
        -- Each screen has its own tag table.
        tags[s] = awful.tag(tags.names, s, tags.layout) 
end
-- }}}
-- {{{ Menu -- Create a laucher widget and a main menu require('freedesktop.utils') freedesktop.utils.terminal = terminal  -- default: "xterm" freedesktop.utils.icon_theme = { 'Faenza', 'Faience' } -- look inside /usr/share/icons/, default: nil (don't use icon theme) require('freedesktop.menu') -- {{{ Screens function mvscr() local scrs = {} for s = 1, capi.screen.count() do scr = 'Screen ' .. s scrs[s] = { scr, function () awful.client.movetoscreen(c,s) end } scrn = awful.util.table.join(scrs, { {"Next Screen", function() awful.client.movetoscreen(c,c.screen+1) end }, {"Prev Screen", function() awful.client.movetoscreen(c,c.screen-1) end }}) end return scrn end function mvtag() local tags_n = {} for t = 1, tag.instances() do --FIXME replace "tag.instances()" with the numbers of tags on mouse.screen tagm = 'Tag ' .. t tags_n[t] = { tagm, function() awful.client.movetotag(tags[client.focus.screen][t]) end } tags_np = awful.util.table.join( tags_n, { {"Next tag", function (c) local curidx = awful.tag.getidx() if curidx == 9 then awful.client.movetotag(tags[client.focus.screen][1]) else awful.client.movetotag(tags[client.focus.screen][curidx + 1]) end end }, {"Prev tag", function (c) local curidx = awful.tag.getidx() if curidx == 1 then awful.client.movetotag(tags[client.focus.screen][9]) else awful.client.movetotag(tags[client.focus.screen][curidx - 1]) end end } }) end return tags_np end function ttag() local tags_n = {} for t = 1, tag.instances() do --FIXME replace "tag.instances()" with the numbers of tags on mouse.screen tagm = 'Toggle Tag ' .. t tags_n[t] = { tagm, function() awful.client.toggletag(tags[client.focus.screen][t]) end } end return tags_n end function clsmenu(args) _menu = self or {} local cls = capi.client.get() local cls_t = {} for k, c in pairs(cls) do cls_t[#cls_t + 1] = { awful.util.escape(c.name) or "", function () if not c:isvisible() then awful.tag.viewmore(c:tags(), c.screen) end capi.client.focus = c c:raise() end, c.icon } end return cls_t end function showNavMenu(menu, args) local cls_t = clsmenu(cls) local tag_n = mvtag() local tag_t = ttag() local scr_n = mvscr() if not menu then menu = {} end c = capi.client.focus fclient = { { "Close", --✖ function() c:kill() end }, { (c.minimized and "Restore") or "Minimize", --⇱ ⇲ function() c.minimized = not c.minimized end },	{ (c.maximized_horizontal and "Restore") or "[M] Maximize", function () c.maximized_horizontal = not c.maximized_horizontal c.maximized_vertical = not c.maximized_vertical end }, { (c.sticky and "Un-Stick") or "[S] Stick", --⚫ ⚪ function() c.sticky = not c.sticky end }, { (c.ontop and "Offtop") or "[T] Ontop", --⤼ ⤽ function() c.ontop = not c.ontop if c.ontop then c:raise() end end }, { ((awful.client.floating.get(c) and "Tile") or "[F] Float"), --▦ ☁ function() awful.client.floating.toggle(c) end }, {"Master", function() c:swap(awful.client.getmaster(1)) end }, {"Slave", function() awful.client.setslave(c) end } } local mynav = { {awful.util.escape(c.class), fclient, c.icon }, {"Move to Tag", tag_n }, {"Toggle Tag", tag_t }, {"Move to Screen", scr_n }, {"Clients", cls_t }, } menu.items = mynav local m = awful.menu.new(menu) m:show(args) return m end -- }}} -- {{{ Menu myawesomemenu = { { "manual", terminal .. " -e man awesome" }, { "edit config", editor_cmd .. " " .. awesome.conffile }, { "restart", awesome.restart }, { "quit", awesome.quit } } myeditors = { { "GVim", "gvim" }, { "GEdit", "gedit"}, { "Geany", "geany"} } exitmenu = { { "Shutdown", "poweroff", freedesktop.utils.lookup_icon({ icon='system-shutdown' }) }, { "Restart", "reboot", freedesktop.utils.lookup_icon({ icon='view-refresh' }) }, { "Lock", "slimlock", freedesktop.utils.lookup_icon({ icon='system-lock-screen' }) }, { "awesome", myawesomemenu, beautiful.awesome_icon } } mymenu = awful.util.table.join({ { "File Manager", fileman, freedesktop.utils.lookup_icon({ icon='file-manager' }) }, { "Browser", browser, freedesktop.utils.lookup_icon({ icon='browser' }) }, { "Terminal", terminal, freedesktop.utils.lookup_icon({ icon='terminal' }) }, }, { { " ", function () awful.menu.hide(mymainmenu) end, nil}, { "Exit", exitmenu, freedesktop.utils.lookup_icon({ icon='exit' }) } }) mymainmenu = awful.menu({ items = mymenu }) mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu }) -- }}} Menu -- Menubar configuration menubar.utils.terminal = terminal -- Set the terminal for applications that require it -- }}} -- {{{ Wibox function closeLastNoti()
screen = mouse.screen
for p,pos in pairs(naughty.notifications[screen]) do
        for i,n in pairs(naughty.notifications[screen][p]) do
                if (n.width == 258) then -- to close only previous bright/vol notifications
                        naughty.destroy(n)
                        break
                end
        end
end

                        -- {{{ Cmus
                        cmusicon = wibox.widget.imagebox()
                        cmusicon:set_image(beautiful.widget_mpd)
                        cmuswidget = wibox.widget.textbox()
                        vicious.register(cmuswidget, vicious.widgets.cmus,
                        function (widget, args)
                                if args["{status}"] == "Stopped" then
                                        return " cmus off "
                                else
                                        return args["{status}"]..': '.. args["{artist}"]..' - '.. args["{title}"]..' ### '.. args["{genre}"]
                                end
                        end, 7)
                        -- }}}
                        -- {{{ Hard Drives

                        fsicon = wibox.widget.imagebox()
                        fsicon:set_image(beautiful.widget_fs)
                        -- vicious.cache(vicious.widgets.fs)
                        fswidget = wibox.widget.textbox()
                        vicious.register(fswidget, vicious.widgets.fs, "<span color='" .. beautiful.fg_green .. "'>${/ used_p}</span>", 10)

                        local function dispdisk()
                                local f, infos
                                local capi = {
                                        mouse = mouse,
                                        screen = screen
                                }

                                f = io.popen("dfc -d | grep /dev/sd")
                                infos = f:read("*all")
                                f:close()

                                showdiskinfo = naughty.notify( {
                                        text	= infos,
                                        font    = font,
                                        fg = beautiful.fg_green,
                                        bg = beautiful.fg_black,
                                        timeout	= 0,
                                        hover_timeout = 0.5,
                                        position = "top_right",
                                        margin = 8,
                                        height = 90,
                                        width = 698,
                                        border_color = beautiful.border_tooltip,
                                        border_width = 1,
                                        -- opacity = 0.94,
                                        screen	= capi.mouse.screen })
                                end

                                fswidget:connect_signal('mouse::enter', function () dispdisk(path) end)
                                fswidget:connect_signal('mouse::leave', function () naughty.destroy(showdiskinfo) end)

                                fsmenu = awful.menu({items = {
                                        { "+ All",  function () exec( scripts .. "mount-all",   false) end },
                                        { "- All",  function () exec( scripts .. "umount-all",  false) end },
                                        { "+ Disk", function () exec( scripts .. "mount-disk",  false) end },
                                        { "- Disk", function () exec( scripts .. "umount-disk", false) end },
                                        { "+ Usb",  function () exec( scripts .. "mount-usb",   false) end },
                                        { "- Usb",  function () exec( scripts .. "umount-usb",  false) end }}
                                })

                                fsicon:buttons(awful.util.table.join(
                                awful.button({ }, 1, function () fsmenu:toggle() end ),
                                awful.button({ }, 3, function () exec(cli_fileman) end)))

                                -- }}}
                                -- {{{ Seperators
                                spacer = wibox.widget.textbox()
                                spacer:set_markup(" ")
                                seperator = wibox.widget.textbox()
                                seperator:set_markup("|")
                                dash = wibox.widget.textbox()
                                dash:set_markup("-")
                                -- }}} 
                                -- {{{ Uptime

                                uptimeicon = wibox.widget.imagebox()
                                uptimeicon:set_image(beautiful.widget_uptime)
                                uptimewidget = wibox.widget.textbox()
                                vicious.register( uptimewidget, vicious.widgets.uptime, "<span color='" .. beautiful.fg_yellow .. "'>$2.$3'</span>")
                                uptimeicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec(powertop) end)))

                                -- }}}

                                -- {{{ Temp

                                tempicon = wibox.widget.imagebox()
                                tempicon:set_image(beautiful.widget_temp)

                                tempwidget = wibox.widget.textbox()
                                vicious.register(tempwidget, vicious.widgets.thermal, "<span color='" .. beautiful.fg_yellow .. "'>$1°C</span>", 9, { "coretemp.0", "core"} )

                                local function disptemp()
                                        local f, infos
                                        local capi = {
                                                mouse = mouse,
                                                screen = screen
                                        }

                                        f = io.popen("sudo hddtemp /dev/sda && sensors | grep Core && sensors | grep temp1")
                                        infos = f:read("*all")
                                        f:close()

                                        showtempinfo = naughty.notify( {
                                                text	= infos,
                                                -- title	= "Temperatures",
                                                font    = font,
                                                fg = beautiful.fg_yellow,
                                                bg = beautiful.fg_black,
                                                timeout	= 0,
                                                hover_timeout = 0.5,
                                                position = "bottom_right",
                                                margin = 8,
                                                height = 88,
                                                width = 460,
                                                border_color = beautiful.border_tooltip,
                                                border_width = 1,
                                                -- opacity = 0.94,
                                                screen	= capi.mouse.screen })
                                        end

                                        uptimewidget:connect_signal('mouse::enter', function () disptemp(path) end)
                                        uptimewidget:connect_signal('mouse::leave', function () naughty.destroy(showtempinfo) end)

                                        -- }}}

                                        -- {{{ Cpu

                                        cpuicon = wibox.widget.imagebox()
                                        cpuicon:set_image(beautiful.widget_cpu)
                                        cpuwidget = wibox.widget.textbox()
                                        vicious.register( cpuwidget, vicious.widgets.cpu, "<span color='" .. beautiful.fg_green .. "'>$1</span>", 3)
                                        cpuicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec(saidar) end)))

                                        -- }}}
                                        -- {{{ Ram

                                        memicon = wibox.widget.imagebox()
                                        memicon:set_image(beautiful.widget_mem)
                                        memwidget = wibox.widget.textbox()
                                        vicious.register(memwidget, vicious.widgets.mem, "<span color='" .. beautiful.fg_blue .. "'>$2</span>", 3)
                                        memicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec(tasks) end)))

                                        local function dispmem()
                                                local f, infos
                                                local capi = {
                                                        mouse = mouse,
                                                        screen = screen
                                                }

                                                f = io.popen("free -m | grep total && free -m | grep Mem")
                                                infos = f:read("*all")
                                                f:close()

                                                showmeminfo = naughty.notify( {
                                                        text	= infos,
                                                        font    = font,
                                                        fg = beautiful.fg_blue,
                                                        bg = beautiful.fg_black,
                                                        timeout	= 0,
                                                        hover_timeout = 0.5,
                                                        position = "top_right",
                                                        -- margin = 10,
                                                        -- height = 61,
                                                        -- width = 540,
                                                        border_color = beautiful.border_tooltip,
                                                        border_width = 1,
                                                        -- opacity = 0.94,
                                                        screen	= capi.mouse.screen })
                                                end

                                                memwidget:connect_signal('mouse::enter', function () dispmem(path) end)
                                                memwidget:connect_signal('mouse::leave', function () naughty.destroy(showmeminfo) end)
                                                -- }}} Ram

                                                -- {{{ Net

                                                netdownicon = wibox.widget.imagebox()
                                                netdownicon:set_image(beautiful.widget_netdown)
                                                netupicon = wibox.widget.imagebox()
                                                netupicon:set_image(beautiful.widget_netup)

                                                wifidowninfo = wibox.widget.textbox()
                                                vicious.register(wifidowninfo, vicious.widgets.net, "<span color='" .. beautiful.fg_green .. "'>${eth0 down_kb}</span>", 1)

                                                wifiupinfo = wibox.widget.textbox()
                                                vicious.register(wifiupinfo, vicious.widgets.net, "<span color='" .. beautiful.fg_red .. "'>${eth0 up_kb}</span>", 1)

                                                local function dispip()
                                                        local f, infos
                                                        local capi = {
                                                                mouse = mouse,
                                                                screen = screen
                                                        }

                                                        f = io.popen( "sh ~/.config/awesome/scripts/ip ")
                                                        infos = f:read("*all")
                                                        f:close()

                                                        showip = naughty.notify( {
                                                                text	= infos,
                                                                font    = font,
                                                                fg = beautiful.fg_green,
                                                                bg = beautiful.fg_black,
                                                                timeout	= 0,
                                                                hover_timeout = 0.5,
                                                                position = "bottom_right",
                                                                margin = 5,
                                                                -- height = 33,
                                                                -- width = 120,
                                                                border_color = beautiful.border_tooltip,
                                                                border_width = 1,
                                                                -- opacity = 0.94,
                                                                screen	= capi.mouse.screen })
                                                        end

                                                        wifidowninfo:connect_signal('mouse::enter', function () dispip(path) end)
                                                        wifidowninfo:connect_signal('mouse::leave', function () naughty.destroy(showip) end)

                                                        local function dispdns()
                                                                local f, infos
                                                                local capi = {
                                                                        mouse = mouse,
                                                                        screen = screen
                                                                }

                                                                f = io.popen("cat /etc/resolv.conf")
                                                                infos = f:read("*all")
                                                                f:close()

                                                                showdns = naughty.notify( {
                                                                        text	= infos,
                                                                        font    = font,
                                                                        fg = beautiful.fg_red,
                                                                        bg = beautiful.fg_black,
                                                                        timeout	= 0,
                                                                        hover_timeout = 0.5,
                                                                        position = "bottom_right",
                                                                        margin = 5,
                                                                        border_color = beautiful.border_tooltip,
                                                                        border_width = 1,
                                                                        -- opacity = 0.94,
                                                                        screen	= capi.mouse.screen })
                                                                end

                                                                wifiupinfo:connect_signal('mouse::enter', function () dispdns(path) end)
                                                                wifiupinfo:connect_signal('mouse::leave', function () naughty.destroy(showdns) end)

                                                                netdownicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec( scripts .. "restartwifi", false ) end)))

                                                                -- }}}
                                                                -- {{{ Mail

                                                                mailcount = wibox.widget.textbox()
                                                                vicious.register(mailcount, vicious.widgets.gmail,
                                                                function (widget, args)
                                                                        return "<span color='" .. theme.fg_yellow .. "'>" .. args["{count}"] .. "</span>"
                                                                end, 120) 
                                                                --the '120' here means check every 2 minutes.

                                                                mailtext = wibox.widget.textbox()
                                                                mailtext:set_text('mail')

                                                                mailicon = wibox.widget.imagebox()
                                                                mailicon:set_image(beautiful.widget_mail)
                                                                mailicon:buttons(awful.util.table.join(
                                                                awful.button({ }, 1, function () exec(mail) end),
                                                                awful.button({ }, 3, function () exec(feed) end)))

                                                                -- }}}
                                                                -- {{{ pacwidget
                                                                pacicon = wibox.widget.imagebox()
                                                                pacicon:set_image(beautiful.widget_pac)
                                                                pacwidget = wibox.widget.textbox()
                                                                vicious.register(pacwidget, vicious.widgets.pkg, "<span color='" .. beautiful.fg_magenta .. "'>$1</span>", 60, "Arch")
                                                                local function updates()
                                                                        local f, infos
                                                                        local capi = {
                                                                                mouse = mouse,
                                                                                screen = screen
                                                                        }

                                                                        f = io.popen("pacman -Qu")
                                                                        infos = f:read("*all")
                                                                        if infos == "" then
                                                                                infos = "No updates"
                                                                        end
                                                                        f:close()

                                                                        showpac = naughty.notify ( {
                                                                                text = infos,
                                                                                position = "top_right",
                                                                                run = function () awful.util.spawn(terminal .. " -e sudo pacman -Su") end,
                                                                                screen = capi.mouse.screen,
                                                                                border_width = 2} )
                                                                        end
                                                                        pacwidget:connect_signal('button::press', function () naughty.destroy(showpac) updates(path) end)


                                                                        -- }}}

                                                                        -- {{{ Volume

                                                                        volicon = wibox.widget.imagebox()
                                                                        volicon:set_image(beautiful.widget_vol)
                                                                        volicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec(mixer) end)))

                                                                        volumewidget = wibox.widget.textbox()
                                                                        vicious.register( volumewidget, vicious.widgets.volume, "<span color='" .. beautiful.fg_red .. "'>$1</span>", 1, "Master" )
                                                                        volumewidget:buttons(awful.util.table.join(
                                                                        awful.button({ }, 1, function () exec( "amixer -q sset Master toggle", false ) end),
                                                                        awful.button({ }, 4, function () exec( "amixer -q sset Master 1dB+", false )   end),
                                                                        awful.button({ }, 5, function () exec( "amixer -q sset Master 1dB-", false )   end)))

                                                                        -- }}}
                                                                        -- {{{ Date widget and calendar pop-up
                                                                        datewidget = wibox.widget.textbox()
                                                                        vicious.register(datewidget, vicious.widgets.date, "%a %b %d, %I:%M%p", 10)

                                                                        local function calendar()
                                                                                local f, infos
                                                                                local capi = {
                                                                                        mouse = mouse,
                                                                                        screen = screen
                                                                                }

                                                                                f = io.popen("cal")
                                                                                infos = f:read("*all")
                                                                                f:close()

                                                                                showcal = naughty.notify( {
                                                                                        text = infos,
                                                                                        timeout = 0,
                                                                                        margin = 10,
                                                                                        position = "top_right",
                                                                                        height = 140,
                                                                                        screen = capi.mouse.screen,
                                                                                        border_width = 2} )
                                                                                end

                                                                                datewidget:connect_signal('button::press', function () naughty.destroy(showcal) calendar(path) end)
                                                                                datewidget:connect_signal('mouse::leave', function () naughty.destroy(showcal) end)
                                                                                -- }}} 

                                                                                -- {{{ Clock & Calendar

                                                                                mytextclock = awful.widget.textclock("<span color='" .. beautiful.fg_blue .. "'>%a %d %b %y</span> <span color='" .. beautiful.fg_grey .. "'>></span> <span color='" .. beautiful.fg_red .. "'>%I:%M %p</span>")
                                                                                mytextclockicon = wibox.widget.imagebox()
                                                                                mytextclockicon:set_image(beautiful.widget_clock)
                                                                                mytextclockicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec("xset dpms force off", false) end)))

                                                                                local calendar = nil
                                                                                local offset = 0

                                                                                function remove_calendar()
                                                                                        if calendar ~= nil then
                                                                                                naughty.destroy(calendar)
                                                                                                calendar = nil
                                                                                                offset = 0
                                                                                        end
                                                                                end

                                                                                function add_calendar(inc_offset)
                                                                                        local save_offset = offset
                                                                                        remove_calendar()
                                                                                        offset = save_offset + inc_offset
                                                                                        local datespec = os.date("*t")
                                                                                        datespec = datespec.year * 12 + datespec.month - 1 + offset
                                                                                        datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
                                                                                        local cal = awful.util.pread("cal -m " .. datespec)
                                                                                        cal = string.gsub(cal, "^%s*(.-)%s*$", "%1")
                                                                                        calendar = naughty.notify({
                                                                                                text = string.format('<span font_desc="%s">%s</span>', font, cal),
                                                                                                position = "top_right",
                                                                                                fg = beautiful.fg_red,
                                                                                                bg = beautiful.fg_black,
                                                                                                timeout = 0,
                                                                                                hover_timeout = 0.5,
                                                                                                border_color = beautiful.border_tooltip,
                                                                                                border_width = 1,
                                                                                                -- opacity = 0.94,                             
                                                                                                -- width = 135,
                                                                                                -- height = 110,
                                                                                        })
                                                                                end

                                                                                mytextclock:connect_signal('mouse::enter', function () add_calendar(0) end)
                                                                                mytextclock:connect_signal('mouse::leave', function () remove_calendar() end)

                                                                                mytextclock:buttons(awful.util.table.join(
                                                                                awful.button({ }, 1, function() add_calendar(1) end), 
                                                                                awful.button({ }, 3, function() add_calendar(-1) end),
                                                                                awful.button({ 'Shift' }, 1, function() add_calendar(12) end),
                                                                                awful.button({ 'Shift' }, 3, function() add_calendar(-12) end)))

                                                                                -- }}}
                                                                                -- {{{ Kernel Info

                                                                                sysicon = wibox.widget.imagebox()
                                                                                sysicon:set_image(beautiful.widget_sys)
                                                                                sysicon:buttons(awful.util.table.join(awful.button({ }, 1, awesome.restart)))

                                                                                syswidget = wibox.widget.textbox()
                                                                                vicious.register(syswidget, vicious.widgets.os, "<span color='" .. beautiful.fg_magenta .. "'>$2</span>")
                                                                                syswidget:buttons(awful.util.table.join(
                                                                                awful.button({ }, 1, function () exec(terminal) end),
                                                                                awful.button({ }, 3, function () exec(root_terminal) end)))

                                                                                local function dispmemo()
                                                                                        local f, infos
                                                                                        local capi = {
                                                                                                mouse = mouse,
                                                                                                screen = screen
                                                                                        }

                                                                                        f = io.popen( "cat ~/.memo" )
                                                                                        infos = f:read("*all")
                                                                                        f:close()

                                                                                        showmemo = naughty.notify( {
                                                                                                text	= infos,
                                                                                                font    = font,
                                                                                                fg = beautiful.fg_magenta,
                                                                                                bg = beautiful.fg_black,
                                                                                                timeout	= 0,
                                                                                                hover_timeout = 0.5,
                                                                                                position = "bottom_right",
                                                                                                -- margin = 4,
                                                                                                -- height = 33,
                                                                                                -- width = 120,
                                                                                                border_color = beautiful.border_tooltip,
                                                                                                border_width = 1,
                                                                                                -- opacity = 0.94,
                                                                                                screen	= capi.mouse.screen })
                                                                                        end

                                                                                        syswidget:connect_signal('mouse::enter', function () dispmemo(path) end)
                                                                                        syswidget:connect_signal('mouse::leave', function () naughty.destroy(showmemo) end)

                                                                                        -- }}}
                                                                                        -- }}}
                                                                                        -- {{{  Create a wibox for each screen and add it
                                                                                        mytopbox = {}
                                                                                        mybotbox = {}
                                                                                        mypromptbox = {}
                                                                                        mylayoutbox = {}
                                                                                        mytaglist = {}
                                                                                        mytaglist.buttons = awful.util.table.join(
                                                                                        awful.button({ }, 1, awful.tag.viewonly),
                                                                                        awful.button({ modkey }, 1, awful.client.movetotag),
                                                                                        awful.button({ }, 3, awful.tag.viewtoggle),
                                                                                        awful.button({ modkey }, 3, awful.client.toggletag),
                                                                                        awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                                                                                        awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                                                                                        )
                                                                                        mytasklist = {}
                                                                                        mytasklist.buttons = awful.util.table.join(
                                                                                        awful.button({ }, 1, function (c)
                                                                                                if c == client.focus then
                                                                                                        c.minimized = true
                                                                                                else
                                                                                                        -- Without this, the following
                                                                                                        -- :isvisible() makes no sense
                                                                                                        c.minimized = false
                                                                                                        if not c:isvisible() then
                                                                                                                awful.tag.viewonly(c:tags()[1])
                                                                                                        end
                                                                                                        -- This will also un-minimize
                                                                                                        -- the client, if needed
                                                                                                        client.focus = c
                                                                                                        c:raise()
                                                                                                end
                                                                                        end),
                                                                                        awful.button({ }, 3, function ()
                                                                                                if instance then
                                                                                                        instance:hide()
                                                                                                        instance = nil
                                                                                                else
                                                                                                        instance = awful.menu.clients({ width=250 })
                                                                                                end
                                                                                        end),
                                                                                        awful.button({ }, 4, function ()
                                                                                                awful.client.focus.byidx(1)
                                                                                                if client.focus then client.focus:raise() end
                                                                                        end),
                                                                                        awful.button({ }, 5, function ()
                                                                                                awful.client.focus.byidx(-1)
                                                                                                if client.focus then client.focus:raise() end
                                                                                        end))

                                                                                        for s = 1, screen.count() do
                                                                                                -- Create a promptbox for each screen
                                                                                                mypromptbox[s] = awful.widget.prompt("<span color='" .. beautiful.fg_red .. "'>Exec </span>")
                                                                                                -- Create an imagebox widget which will contains an icon indicating which layout we're using.
                                                                                                -- We need one layoutbox per screen.
                                                                                                mylayoutbox[s] = awful.widget.layoutbox(s)
                                                                                                mylayoutbox[s]:buttons(awful.util.table.join(
                                                                                                awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                                                                                                awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                                                                                                awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                                                                                                awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))


                                                                                                -- Create a taglist widget
                                                                                                mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

                                                                                                -- Create a tasklist widget
                                                                                                mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
                                                                                                -- }}} 
                                                                                                -- {{{ Top wibox
                                                                                                mytopbox[s] = awful.wibox({ position = "top", screen = s })
                                                                                                local left_layout = wibox.layout.fixed.horizontal()
                                                                                                left_layout:add(mylauncher)
                                                                                                left_layout:add(mytaglist[s])
                                                                                                left_layout:add(spacer)
                                                                                                left_layout:add(cmusicon)
                                                                                                left_layout:add(cmuswidget)
                                                                                                left_layout:add(spacer)
                                                                                                left_layout:add(mypromptbox[s])
                                                                                                local right_layout = wibox.layout.fixed.horizontal()
                                                                                                right_layout:add(uptimeicon)
                                                                                                right_layout:add(uptimewidget)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(seperator)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(cpuicon)
                                                                                                right_layout:add(cpuwidget)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(seperator)
                                                                                                right_layout:add(spacer) 
                                                                                                right_layout:add(memicon)
                                                                                                right_layout:add(memwidget)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(seperator)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(fsicon)
                                                                                                right_layout:add(fswidget)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(seperator)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(netdownicon)
                                                                                                right_layout:add(wifidowninfo)
                                                                                                right_layout:add(netupicon)
                                                                                                right_layout:add(wifiupinfo)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(seperator)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(sysicon)
                                                                                                right_layout:add(syswidget)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(seperator)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(pacicon)
                                                                                                right_layout:add(pacwidget)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(seperator)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(mailicon)
                                                                                                right_layout:add(mailcount)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(seperator)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(volicon)
                                                                                                right_layout:add(volumewidget)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(seperator)
                                                                                                right_layout:add(spacer)
                                                                                                --    right_layout:add(datewidget)
                                                                                                right_layout:add(mytextclockicon)
                                                                                                right_layout:add(mytextclock)
                                                                                                right_layout:add(spacer)
                                                                                                right_layout:add(mylayoutbox[s])
                                                                                                if s == 1 then right_layout:add(wibox.widget.systray()) end
                                                                                                local layout = wibox.layout.align.horizontal()
                                                                                                layout:set_left(left_layout)
                                                                                                --layout:set_middle(mytasklist[s])
                                                                                                layout:set_right(right_layout)
                                                                                                mytopbox[s]:set_widget(layout)
                                                                                                -- }}} 
                                                                                                -- {{{ Bottom wibox
                                                                                                mybotbox[s] = awful.wibox({ position = "bottom", screen = s, height = barheight })
                                                                                                local layout = wibox.layout.align.horizontal()
                                                                                                layout:set_middle(mytasklist[s])
                                                                                                --if s == 1 then layout:set_right(wibox.widget.systray()) end
                                                                                                mybotbox[s]:set_widget(layout)
                                                                                        end
                                                                                        -- }}}
                                                                                        -- {{{ Mouse bindings
                                                                                        root.buttons(awful.util.table.join(
                                                                                        awful.button({ }, 3, function () mymainmenu:toggle() end),
                                                                                        awful.button({ }, 4, awful.tag.viewnext),
                                                                                        awful.button({ }, 5, awful.tag.viewprev)
                                                                                        ))
                                                                                        -- }}}
                                                                                        -- {{{ Key bindings
                                                                                        globalkeys = awful.util.table.join(
                                                                                        -- Dropdown urxvtc
                                                                                        awful.key ( { altkey }, "`",           function() scratch.drop ( "urxvtc", "top", "center", 1.00, 0.50, true ) end ),
                                                                                        -- Print screen
                                                                                        awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/Pictures/Screenshots/ 2>/dev/null'") end),
                                                                                        -- Media keys
                                                                                        awful.key ( { }, "XF86AudioMute",           function() awful.util.spawn ( cmd.mute ) end ),
                                                                                        awful.key ( { }, "XF86AudioLowerVolume",    function() awful.util.spawn ( cmd.voldn ) end ),
                                                                                        awful.key ( { }, "XF86AudioRaiseVolume",    function() awful.util.spawn ( cmd.volup ) end ),
                                                                                        awful.key ( { }, "XF86AudioPrev",           function() awful.util.spawn ( cmd.prev ) end ),
                                                                                        awful.key ( { }, "XF86AudioPlay",           function() awful.util.spawn ( cmd.play ) end ),
                                                                                        awful.key ( { }, "XF86AudioNext",           function() awful.util.spawn ( cmd.skip ) end ),
                                                                                        awful.key ( { }, "XF86AudioStop",           function() awful.util.spawn ( cmd.stop ) end ),
                                                                                        awful.key({ modkey }, "c",                  function () os.execute("xsel -p -o | xsel -i -b") end),
                                                                                        awful.key({ altkey },             "w",                function () exec( browser, false )                                 end),
                                                                                        awful.key({ altkey },             "f",                function () exec( filemancli, false )                                 end),

                                                                                        awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
                                                                                        awful.key({ modkey,           }, "q",   awful.tag.viewprev       ),
                                                                                        awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
                                                                                        awful.key({ modkey,           }, "w",  awful.tag.viewnext       ),
                                                                                        awful.key({ modkey,           }, "Up",   function () awful.layout.inc(layouts, 1) end       ),
                                                                                        awful.key({ modkey,           }, "Down",  function () awful.layout.inc(layouts, -1) end       ),
                                                                                        awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
                                                                                        awful.key({ altkey,           }, "m",   function() awful.util.spawn ( "dmenu_run" ) end       ),
                                                                                        awful.key({ modkey, altkey          }, "return",   function() awful.util.spawn ( root_terminal ) end       ),
                                                                                        awful.key({  altkey          }, "e",   function() awful.util.spawn ( fileman ) end       ),
                                                                                        awful.key({  modkey          }, "s",   function() awful.util.spawn ( "sh /home/nir/scripts/spotlight" ) end       ),
                                                                                        --  unminimize windows
                                                                                        awful.key({ modkey, "Shift"   }, "n",
                                                                                        function ()
                                                                                                local allclients = client.get(mouse.screen)

                                                                                                for _,c in ipairs(allclients) do
                                                                                                        if c.minimized and c:tags()[mouse.screen] ==
                                                                                                                awful.tag.selected(mouse.screen) then
                                                                                                                c.minimized = false
                                                                                                                client.focus = c
                                                                                                                c:raise()
                                                                                                                return
                                                                                                        end
                                                                                                end
                                                                                        end),
                                                                                        -- 
                                                                                        --  Screen focus
                                                                                        awful.key({modkey,            }, "F1",     function () awful.screen.focus(2) end),
                                                                                        awful.key({modkey,            }, "F2",     function () awful.screen.focus(1) end),

                                                                                        -- Client focus
                                                                                        awful.key({ modkey,           }, "j",
                                                                                        function ()
                                                                                                awful.client.focus.byidx( 1)
                                                                                                if client.focus then client.focus:raise() end
                                                                                        end),
                                                                                        awful.key({ modkey,           }, "k",
                                                                                        function ()
                                                                                                awful.client.focus.byidx(-1)
                                                                                                if client.focus then client.focus:raise() end
                                                                                        end),
                                                                                        --awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

                                                                                        -- Layout manipulation
                                                                                        awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
                                                                                        awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
                                                                                        awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
                                                                                        awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
                                                                                        awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
                                                                                        awful.key({ modkey,           }, "Tab",
                                                                                        function ()
                                                                                                awful.client.focus.history.previous()
                                                                                                if client.focus then
                                                                                                        client.focus:raise()
                                                                                                end
                                                                                        end),
                                                                                        -- Move & Resize
                                                                                        awful.key({ modkey, altkey }, "Right",  function () awful.client.moveresize( 0,  0, 40, 0) end),
                                                                                        awful.key({ modkey, altkey }, "Left",  function () awful.client.moveresize( 0,  0, -40, 0) end),
                                                                                        awful.key({ modkey, altkey }, "Up", function () awful.client.moveresize(0, 0,  0,  -40) end),
                                                                                        awful.key({ modkey, altkey }, "Down", function () awful.client.moveresize(0, 0,  0,  40) end),
                                                                                        awful.key({ altkey }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
                                                                                        awful.key({ altkey }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
                                                                                        awful.key({ altkey }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
                                                                                        awful.key({ altkey }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),

                                                                                        -- Escape from keyboard focus trap (eg Flash plugin in Firefox)
                                                                                        awful.key({ modkey, "Control" }, "Escape", function ()
                                                                                                awful.util.spawn("xdotool getactivewindow mousemove --window %1 0 0 click --clearmodifiers 2")
                                                                                        end),

                                                                                        -- Standard programs
                                                                                        awful.key({ }, "XF86Calculator", function() awful.util.spawn(calc) end ),
                                                                                        awful.key({ altkey,           }, "F4", function() awful.util.spawn("xkill") end), -- xkill
                                                                                        awful.key({ }, "XF86HomePage", function() awful.util.spawn(browser) end ),
                                                                                        awful.key({ }, "XF86Mail", function() awful.util.spawn(mail) end ),
                                                                                        awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminale) end),
                                                                                        awful.key({ modkey, "Control" }, "r", awesome.restart),
                                                                                        awful.key({ modkey, "Shift"   }, "q", awesome.quit),

                                                                                        awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
                                                                                        awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
                                                                                        awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
                                                                                        awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
                                                                                        awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
                                                                                        awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
                                                                                        awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
                                                                                        awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

                                                                                        awful.key({ modkey, "Control" }, "n", awful.client.restore),

                                                                                        -- Prompt
                                                                                        awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),


                                                                                        -- Run in terminal
                                                                                        awful.key({ modkey, "Shift"   }, "r",
                                                                                        function ()
                                                                                                awful.prompt.run({ prompt = "Run in terminal: " },
                                                                                                mypromptbox[mouse.screen].widget,
                                                                                                function (...) awful.util.spawn(terminal .. " -e " .. ...) end,
                                                                                                awful.completion.shell,
                                                                                                awful.util.getdir("cache") .. "/history")
                                                                                        end),

                                                                                        awful.key({ modkey }, "x",
                                                                                        function ()
                                                                                                awful.prompt.run({ prompt = "Run Lua code: " },
                                                                                                mypromptbox[mouse.screen].widget,
                                                                                                awful.util.eval, nil,
                                                                                                awful.util.getdir("cache") .. "/history_eval")
                                                                                        end),
                                                                                        -- Run or raise applications with dmenu
                                                                                        awful.key({ altkey }, "F2",
                                                                                        function ()
                                                                                                local f_reader = io.popen("dmenu_run")
                                                                                                local command = assert(f_reader:read('*a'))
                                                                                                f_reader:close()
                                                                                                if command == "" then return end

                                                                                                -- Check throught the clients if the class match the command
                                                                                                local lower_command=string.lower(command)
                                                                                                for k, c in pairs(client.get()) do
                                                                                                        local class=string.lower(c.class)
                                                                                                        if string.match(class, lower_command) then
                                                                                                                for i, v in ipairs(c:tags()) do
                                                                                                                        awful.tag.viewonly(v)
                                                                                                                        c:raise()
                                                                                                                        c.minimized = false
                                                                                                                        return
                                                                                                                end
                                                                                                        end
                                                                                                end
                                                                                                awful.util.spawn(command)
                                                                                        end),
                                                                                        -- Move client to monitor
                                                                                        awful.key({ modkey, "Shift"   }, "F1", function (c) awful.client.movetoscreen(c, 2) end),
                                                                                        awful.key({ modkey, "Shift"   }, "F2", function (c) awful.client.movetoscreen(c, 1) end),
                                                                                        -- 
                                                                                        -- Menubar
                                                                                        awful.key({ modkey }, "p", function() menubar.show() end)
                                                                                        )

                                                                                        clientkeys = awful.util.table.join(
                                                                                        awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
                                                                                        awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
                                                                                        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
                                                                                        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
                                                                                        awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
                                                                                        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
                                                                                        awful.key({ modkey,           }, "n",
                                                                                        function (c)
                                                                                                -- The client currently has the input focus, so it cannot be
                                                                                                -- minimized, since minimized clients can't have the focus.
                                                                                                c.minimized = true
                                                                                        end),
                                                                                        awful.key({ modkey,           }, "m",
                                                                                        function (c)
                                                                                                c.maximized_horizontal = not c.maximized_horizontal
                                                                                                c.maximized_vertical   = not c.maximized_vertical
                                                                                        end)
                                                                                        )

                                                                                        -- Bind all key numbers to tags.
                                                                                        -- Be careful: we use keycodes to make it works on any keyboard layout.
                                                                                        -- This should map on the top row of your keyboard, usually 1 to 9.
                                                                                        for i = 1, 9 do
                                                                                                globalkeys = awful.util.table.join(globalkeys,
                                                                                                awful.key({ modkey }, "#" .. i + 9,
                                                                                                function ()
                                                                                                        local screen = mouse.screen
                                                                                                        local tag = awful.tag.gettags(screen)[i]
                                                                                                        if tag then
                                                                                                                awful.tag.viewonly(tag)
                                                                                                        end
                                                                                                end),
                                                                                                awful.key({ modkey, "Control" }, "#" .. i + 9,
                                                                                                function ()
                                                                                                        local screen = mouse.screen
                                                                                                        local tag = awful.tag.gettags(screen)[i]
                                                                                                        if tag then
                                                                                                                awful.tag.viewtoggle(tag)
                                                                                                        end
                                                                                                end),
                                                                                                awful.key({ modkey, "Shift" }, "#" .. i + 9,
                                                                                                function ()
                                                                                                        local tag = awful.tag.gettags(client.focus.screen)[i]
                                                                                                        if client.focus and tag then
                                                                                                                awful.client.movetotag(tag)
                                                                                                        end
                                                                                                end),
                                                                                                awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                                                                                                function ()
                                                                                                        local tag = awful.tag.gettags(client.focus.screen)[i]
                                                                                                        if client.focus and tag then
                                                                                                                awful.client.toggletag(tag)
                                                                                                        end
                                                                                                end))
                                                                                        end

                                                                                        clientbuttons = awful.util.table.join(
                                                                                        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
                                                                                        awful.button({ modkey }, 1, awful.mouse.client.move),
                                                                                        awful.button({ modkey }, 3, awful.mouse.client.resize))

                                                                                        -- Set keys
                                                                                        root.keys(globalkeys)
                                                                                        -- }}}
                                                                                        -- {{{ Rules
                                                                                        awful.rules.rules = {
                                                                                                -- All clients will match this rule.
                                                                                                { rule = { },
                                                                                                properties = { border_width = beautiful.border_width,
                                                                                                border_color = beautiful.border_normal,
                                                                                                focus = awful.client.focus.filter,
                                                                                                keys = clientkeys,
                                                                                                maximized_vertical = false,
                                                                                                maximized_horizontal = false,
                                                                                                buttons = clientbuttons } },
                                                                                                { rule_any = { class = { "MPlayer", "Umplayer", "Smplayer2", "Vlc" } },
                                                                                                properties = { tag = tags[1][5], floating = true } },
                                                                                                { rule = { class = "pinentry" },
                                                                                                properties = { floating = true } },
                                                                                                { rule = { class = "Gimp-2.8" },
                                                                                                properties = { tag = tags[1][4], maximized = true } },
                                                                                                { rule = { class = "URxvt" },
                                                                                                properties = { size_hints_honor = false } },
                                                                                                { rule_any = { class = { "Eclipse", "Geany" } },
                                                                                                properties = { tag = tags[1][3] } },
                                                                                                { rule_any = { class = { "libreoffice-startcenter", "libreoffice-writer", "libreoffice-calc", "libreoffice-impress", "libreoffice-base", "libreoffice-draw", "libreoffice-math" } },
                                                                                                properties = { tag = tags[1][5] } },
                                                                                                { rule = { class = "Galculator" },
                                                                                                properties = { floating = true } },
                                                                                                { rule = { instance = "plugin-container" },
                                                                                                properties = { floating = true } },
                                                                                                { rule = { instance = "exe" },
                                                                                                properties = { floating = true } },
                                                                                                -- Set Firefox to always map on tags number 2 of screen 1.
                                                                                                { rule = { class = "Google-Chrome" }, except_any = { instance = { "Dialog", "Browser" } },
                                                                                                properties = { tag = tags[1][1], floating = true, border_width = 0 } },
                                                                                        }
                                                                                        -- }}}
                                                                                        -- {{{ Signals

                                                                                        -- Signal function to execute when a new client appears.
                                                                                        client.connect_signal("manage", function (c, startup)
                                                                                                -- Enable sloppy focus
                                                                                                c:connect_signal("mouse::enter", function(c)
                                                                                                        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                                                                                                                and awful.client.focus.filter(c) then
                                                                                                                client.focus = c
                                                                                                        end
                                                                                                end)

                                                                                                if not startup then
                                                                                                        -- Set the windows at the slave,
                                                                                                        -- i.e. put it at the end of others instead of setting it master.
                                                                                                        -- awful.client.setslave(c)

                                                                                                        -- Put windows in a smart way, only if they does not set an initial position.
                                                                                                        if not c.size_hints.user_position and not c.size_hints.program_position then
                                                                                                                awful.placement.no_overlap(c)
                                                                                                                awful.placement.no_offscreen(c)
                                                                                                        end
                                                                                                end

                                                                                                local titlebars_enabled = true
                                                                                                if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
                                                                                                        -- Widgets that are aligned to the left
                                                                                                        local left_layout = wibox.layout.fixed.horizontal()
                                                                                                        left_layout:add(space)
                                                                                                        -- left_layout:add(awful.titlebar.widget.iconwidget(c))

                                                                                                        -- Widgets that are aligned to the right
                                                                                                        local right_layout = wibox.layout.fixed.horizontal()
                                                                                                        right_layout:add(awful.titlebar.widget.floatingbutton(c))
                                                                                                        right_layout:add(awful.titlebar.widget.ontopbutton(c))
                                                                                                        right_layout:add(awful.titlebar.widget.stickybutton(c))
                                                                                                        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
                                                                                                        right_layout:add(awful.titlebar.widget.closebutton(c))

                                                                                                        -- The title goes in the middle
                                                                                                        local title = awful.titlebar.widget.titlewidget(c)
                                                                                                        title:buttons(awful.util.table.join(
                                                                                                        awful.button({ }, 1, function()
                                                                                                                client.focus = c
                                                                                                                c:raise()
                                                                                                                awful.mouse.client.move(c)
                                                                                                        end),
                                                                                                        awful.button({ }, 3, function()
                                                                                                                client.focus = c
                                                                                                                c:raise()
                                                                                                                awful.mouse.client.resize(c)
                                                                                                        end)
                                                                                                        ))

                                                                                                        -- Now bring it all together
                                                                                                        local layout = wibox.layout.align.horizontal()
                                                                                                        layout:set_left(left_layout)
                                                                                                        layout:set_right(right_layout)
                                                                                                        layout:set_middle(title)

                                                                                                        awful.titlebar(c):set_widget(layout)
                                                                                                end
                                                                                        end)

                                                                                        client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
                                                                                        client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

                                                                                        -- }}}
