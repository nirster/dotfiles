--	vim: tabstop=4 shiftwidth=4 softtabstop=4
--
--		[Awesome 3.5 rc.lua]		--
--		[based on Colored config by	-- 
--		TheImmortalPhoenix]		--
--		[by Kirafreaky]			--

-- [ Required Libraries

gears		    = require("gears")
awful           = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
wibox           = require("wibox")
beautiful       = require("beautiful")
naughty         = require("naughty")
vicious         = require("vicious")
menubar 	    = require("menubar")
scratch		    = require("scratch")


-- ]

-- [ Autostart

function run_once(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end 

--run_once("start-pulseaudio-x11")
-- ]

-- [ Error Handling

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

do
    in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = err })
        in_error = false
    end)
end
-- ]

-- [ Variable Definitions

-- Useful Paths
home = os.getenv("HOME")
confdir = home .. "/.config/awesome"
scriptdir = confdir .. "/scripts/"
themes = confdir .. "/themes"

-- Choose Your Theme
active_theme = themes .. "/tron"
beautiful.init(active_theme .. "/theme.lua")

terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
gui_editor = "gvim"
browser = "google-chrome --audio-buffer-size=4096"
--browser = "chromium" 
mail     = "google-chrome --audio-buffer-size=4096 www.gmail.com"
fileman = "thunar " .. home
manager = "thunar "
torrent_client = "transmission-gtk"
calc    = "gnome-calculator"
cli_fileman = terminal .. " -title Ranger -name Ranger -e ranger "
music = terminal .. " -title Music -e cd ~/music && cmus "
chat = terminal .. " -title Chat -e weechat-curses "
torrent = terminal .. " -title Torrent -e sh /home/kirafreaky/.scripts/torrent "
tasks = terminal .. " -e htop "

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"
control= "Control"
shift  = "Shift"

-- Table of layouts 
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.right,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.tile.left,
    awful.layout.suit.floating,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier
}
-- ]

-- [ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- ]

-- [ Tags

tags = {}
for s = 1, screen.count() do
    --tags[s] = awful.tag({ "1 ", "2 ", "3 ", "4 ", "5 ", "6" }, s,
    tags[s] = awful.tag({ "web", "term", "files", "docs", "float" }, s,
    { layouts[1], layouts[2], 
    layouts[1], layouts[4], layouts[6]
})

-- awful.tag.seticon(active_theme .. "/widgets/magenta/arch_10x10.png", tags[s][1])
--awful.tag.seticon(active_theme .. "/widgets/Ultimate/diskette.png", tags[s][1])
--awful.tag.seticon(active_theme .. "/widgets/Ultimate/fox.png", tags[s][2])
--awful.tag.seticon(active_theme .. "/widgets/Ultimate/mouse_01.png", tags[s][3])
--awful.tag.seticon(active_theme .. "/widgets/Ultimate/mail.png", tags[s][4])
--awful.tag.seticon(active_theme .. "/widgets/Ultimate/pacman.png", tags[s][5])
--awful.tag.seticon(active_theme .. "/widgets/Ultimate/ac.png", tags[s][6])

end

-- ]

-- [ Menu

myawesomemenu = {
    { "Manual", terminal .. " -e man awesome" },
    { "Theme", editor_cmd .. "/home/kirafreaky/.config/awesome/themes/niceandclean/theme.lua"},
    { "Config", terminal .. " -e vim .config/awesome/rc.lua" },
    { "Quit", awesome.quit }

}


mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, 
beautiful.awesome_icon }          
                  }
              })

              mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
              menu = mymainmenu })


              -- ]

              -- [ Clock & Date

              datewidget = wibox.widget.textbox()
              vicious.register(datewidget, vicious.widgets.date, "%b %d  %R", 30)
              mytextclock = awful.widget.textclock()
              mytextclockicon = wibox.widget.imagebox()
              mytextclockicon:set_image(beautiful.widget_clock)

              -- Calendar with the Clock

              local os = os
              local string = string
              local table = table
              local util = awful.util

              char_width = nil
              text_color = theme.fg_normal or "#FFFFFF"
              today_color = theme.fg_focus or "#FF7100"
              calendar_width = 21

              local calendar = nil
              local offset = 0

              local data = nil

              local function pop_spaces(s1, s2, maxsize)
                  local sps = ""
                  for i = 1, maxsize - string.len(s1) - string.len(s2) do
                      sps = sps .. " "
                  end
                  return s1 .. sps .. s2
              end

              local function create_calendar()
                  offset = offset or 0

                  local now = os.date("*t")
                  local cal_month = now.month + offset
                  local cal_year = now.year
                  if cal_month > 12 then
                      cal_month = (cal_month % 12)
                      cal_year = cal_year + 1
                  elseif cal_month < 1 then
                      cal_month = (cal_month + 12)
                      cal_year = cal_year - 1
                  end

                  local last_day = os.date("%d", os.time({ day = 1, year = cal_year,
                  month = cal_month + 1}) - 86400)
                  local first_day = os.time({ day = 1, month = cal_month, year = cal_year})
                  local first_day_in_week =
                  os.date("%w", first_day)
                  local result = "Su Mo Tu We Th Fr Sa\n"
                  for i = 1, first_day_in_week do
                      result = result .. " "
                  end

                  local this_month = false
                  for day = 1, last_day do
                      local last_in_week = (day + first_day_in_week) % 7 == 0
                      local day_str = pop_spaces("", day, 2) .. (last_in_week and "" or " ")
                      if cal_month == now.month and cal_year == now.year and day == now.day then
                          this_month = true
                          result = result ..
                          string.format('<span weight="bold" foreground = "%s">%s</span>',
                          today_color, day_str)
                      else
                          result = result .. day_str
                      end
                      if last_in_week and day ~= last_day then
                          result = result .. "\n"
                      end
                  end

                  local header
                  if this_month then
                      header = os.date("%a, %d %b %Y")
                  else
                      header = os.date("%B %Y", first_day)
                  end
                  return header, string.format('<span font="%s" foreground="%s">%s</span>',
                  theme.font, text_color, result)
              end

              local function calculate_char_width()
                  return beautiful.get_font_height(theme.font) * 0.555
              end

              function hide()
                  if calendar ~= nil then
                      naughty.destroy(calendar)
                      calendar = nil
                      offset = 0
                  end
              end

              function show(inc_offset)
                  inc_offset = inc_offset or 0

                  local save_offset = offset
                  hide()
                  offset = save_offset + inc_offset

                  local char_width = char_width or calculate_char_width()
                  local header, cal_text = create_calendar()
                  calendar = naughty.notify({ title = header,
                  text = cal_text,
                  timeout = 0, hover_timeout = 0.5,
              })
          end

          datewidget:connect_signal("mouse::enter", function() show(0) end)
          datewidget:connect_signal("mouse::leave", hide)
          datewidget:buttons(util.table.join( awful.button({ }, 1, function() show(-1) end),
          awful.button({ }, 3, function() show(1) end)))

          -- ]


          -- [ Volume

          volicon = wibox.widget.imagebox()
          volicon:set_image(beautiful.widget_vol)
          volumewidget = wibox.widget.textbox()
          vicious.register( volumewidget, vicious.widgets.volume, "<span color=\"#339dff\">$1%</span>", 1, "Master" )
          volumewidget:buttons(awful.util.table.join(
          awful.button({ }, 1, function () awful.util.spawn("amixer -q set Master toggle", false) end),
          awful.button({ }, 3, function () awful.util.spawn("".. terminal.. " -e alsamixer", true) end),
          awful.button({ }, 4, function () awful.util.spawn("amixer -q -c 0 set Master 3+ unmute", false) end),
          awful.button({ }, 5, function () awful.util.spawn("amixer -q -c 0 set Master 3- unmute", false) end)
          ))

          -- ]

          --  Cmus
          cmusicon = wibox.widget.imagebox()
          cmusicon:set_image(beautiful.widget_mpd)
          cmuswidget = wibox.widget.textbox()
          vicious.register(cmuswidget, vicious.widgets.cmus,
          function (widget, args)

              string = "<span color='" .. beautiful.fg_magenta .. "'>" .. args["{title}"] .. "</span> <span color='" .. beautiful.fg_black .. "'>-</span> <span color='" .. beautiful.fg_white .. "'>" .. args["{artist}"] .. "</span>"
              -- play
              if (args["{status}"] == "Playing") then
                  cmuswidget.visible = true
                  return string

                  -- pause
              elseif (args["{status}"] == "Paused") then
                  cmuswidget.visible = true
                  return "<span color='" .. beautiful.fg_blu.."'>cmus</span> <span color='" .. beautiful.fg_white.."'>paused</span>"

                  -- stop
              elseif (args["{status}"] == "Stopped") then
                  cmuswidget.visible = true
                  return "<span color='" .. beautiful.fg_blu.."'>cmus</span> <span color='" .. beautiful.fg_white.."'>stopped</span>"

                  -- not running
              else
                  cmuswidget.visible = true
                  return "<span color='" .. beautiful.fg_blu.."'>cmus</span> <span color='" .. beautiful.fg_white.."'>off</span>"
              end

          end, 1)
          cmuswidget:buttons(awful.util.table.join(
          awful.button({ }, 1, function () awful.util.spawn(" sh /home/nir/scripts/cplay ") end)
          ))


          -- [ Net

          netdownicon = wibox.widget.imagebox()
          netdownicon:set_image(beautiful.widget_netdown)
          netupicon = wibox.widget.imagebox()
          netupicon:set_image(beautiful.widget_netup)

          --Wifi
          wifiicon = wibox.widget.imagebox()
          wifiicon:set_image(beautiful.widget_wifi)
          --wifiwidget = wibox.widget.textbox()
          --vicious.register(wifiwidget,vicious.widgets.wifi,"<span color=\"#339dff\">${ssid} ${linp}%</span>", 3, "eth0")


          wifidowninfo = wibox.widget.textbox()
          vicious.register(wifidowninfo, vicious.widgets.net, "<span color=\"#2fffdc\">${eth0 down_kb}</span>", 1)

          wifiupinfo = wibox.widget.textbox()
          vicious.register(wifiupinfo, vicious.widgets.net, "<span color=\"#b93aff\">${eth0 up_kb}</span>", 1)

          local function dispip()
              local f, infos
              local capi = {
                  mouse = mouse,
                  screen = screen
              }

              f = io.popen("sh ~/.config/awesome/scripts/ip")
              infos = f:read("*all")
              f:close()

              showip = naughty.notify( {
                  text	= infos,
                  timeout	= 0,
                  position = "top_right",
                  margin = 10,
                  height = 33,
                  width = 140,
                  border_color = '#404040',
                  border_width = 1,
                  -- opacity = 0.95,
                  screen	= capi.mouse.screen })
              end

              wifidowninfo:connect_signal('mouse::enter', function () dispip(path) end)
              wifidowninfo:connect_signal('mouse::leave', function () naughty.destroy(showip) end)

              -- ]


              -- [ Cpu

              cpuicon = wibox.widget.imagebox()
              cpuicon:set_image(beautiful.widget_cpu)
              cpuwidget = wibox.widget.textbox()
              vicious.register( cpuwidget, vicious.widgets.cpu, "<span color=\"#2fffdc\">$1%</span>", 3)
              cpuicon:buttons(awful.util.table.join(
              awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -geometry 80x18 -e saidar -c", false) end)
              ))
              cpuwidget:buttons(awful.util.table.join(
              awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -geometry 80x18 -e saidar -c", false) end)
              ))
              -- ]

              -- [ Ram

              memicon = wibox.widget.imagebox()
              memicon:set_image(beautiful.widget_mem)
              memwidget = wibox.widget.textbox()
              vicious.register(memwidget, vicious.widgets.mem, "<span color=\"#339dff\">$2 MB</span>", 1)
              memicon:buttons(awful.util.table.join(
              awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -e sudo htop", false) end)
              ))
              memwidget:buttons(awful.util.table.join(
              awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -e sudo htop", false) end)
              ))

              -- ]

              -- {{{ Mail
              mailcount = wibox.widget.textbox()
              vicious.register(mailcount, vicious.widgets.gmail,
              function (widget, args)
                  return "<span color='" .. theme.fg_cyan .. "'>" .. args["{count}"] .. "</span>"
              end, 120) 
              --the '120' here means check every 2 minutes.
              mailtext = wibox.widget.textbox()
              mailtext:set_text('mail')

              mailicon = wibox.widget.imagebox()
              mailicon:set_image(beautiful.widget_gmail)
              mailicon:buttons(awful.util.table.join(
              awful.button({ }, 1, function () awful.util.spawn(mail) end),
              awful.button({ }, 3, function () awful.util.spawn(feed) end)))
              -- }}}

              -- [ Hard Drives

              fsicon = wibox.widget.imagebox()
              fsicon:set_image(beautiful.widget_fs)
              -- vicious.cache(vicious.widgets.fs)
              fswidget = wibox.widget.textbox()
              vicious.register(fswidget, vicious.widgets.fs, "<span color=\"#7788af\">${/ used_p}%</span>", 10)

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
                      timeout	= 0,
                      position = "top_right",
                      margin = 10,
                      height = 130,
                      width = 680,
                      border_color = '#404040',
                      border_width = 1,
                      -- opacity = 0.95,
                      screen	= capi.mouse.screen })
                  end

                  fswidget:connect_signal('mouse::enter', function () dispdisk(path) end)
                  fswidget:connect_signal('mouse::leave', function () naughty.destroy(showdiskinfo) end)

                  -- ]

                  -- [ Vol 
                  volwidget = wibox.widget.textbox()
                  vicious.register(volwidget, vicious.widgets.volume, "$1%", 1, "Master")

                  -- ]

                  -- [ Spacers

                  rbracket = wibox.widget.textbox()
                  rbracket:set_text(']')
                  lbracket = wibox.widget.textbox()
                  lbracket:set_text('[')
                  line = wibox.widget.textbox()
                  line:set_text('|')
                  space = wibox.widget.textbox()
                  space:set_text(' ')

                  -- ]

                  -- [ Layout

                  mywibox = {}
                  mybottomwibox = {}
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
                          c.minimized = false
                          if not c:isvisible() then
                              awful.tag.viewonly(c:tags()[1])
                          end
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

                      mypromptbox[s] = awful.widget.prompt()

                      mylayoutbox[s] = awful.widget.layoutbox(s)
                      mylayoutbox[s]:buttons(awful.util.table.join(
                      awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                      awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                      awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                      awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

                      mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

                      mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

                      mywibox[s] = awful.wibox({ position = "top", screen = s, border_width = 0, height = 20 })

                      left_layout = wibox.layout.fixed.horizontal()
                      left_layout:add(mylauncher)
                      left_layout:add(mytaglist[s])
                      left_layout:add(space)
                      left_layout:add(cmusicon)
                      left_layout:add(cmuswidget)
                      left_layout:add(space)
                      left_layout:add(space)
                      left_layout:add(mypromptbox[s])

                      right_layout = wibox.layout.fixed.horizontal()
                      right_layout:add(netdownicon)
                      right_layout:add(wifidowninfo)
                      right_layout:add(space)
                      right_layout:add(netupicon)
                      right_layout:add(wifiupinfo)
                      right_layout:add(space)
                      right_layout:add(space)
                      right_layout:add(memicon)
                      right_layout:add(memwidget)
                      right_layout:add(space)
                      right_layout:add(space)
                      right_layout:add(cpuicon)
                      right_layout:add(cpuwidget)
                      right_layout:add(space)
                      right_layout:add(space)
                      right_layout:add(fsicon)
                      right_layout:add(fswidget)
                      right_layout:add(space)
                      right_layout:add(space)
                      right_layout:add(volicon)
                      right_layout:add(volumewidget)
                      right_layout:add(space)
                      right_layout:add(space)
                      right_layout:add(mailicon)
                      right_layout:add(mailcount)
                      right_layout:add(space)
                      right_layout:add(space)
                      right_layout:add(mytextclockicon)
                      right_layout:add(datewidget)
                      right_layout:add(space)

                      layout = wibox.layout.align.horizontal()
                      layout:set_left(left_layout)
                      layout:set_right(right_layout)

                      mywibox[s]:set_widget(layout)

                      mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = 20 })
                      mybottomwibox[s].visible = true

                      bottom_left_layout = wibox.layout.fixed.horizontal()
                      bottom_left_layout:add(space) 

                      bottom_right_layout = wibox.layout.fixed.horizontal()
                      bottom_right_layout:add(space) 
                      if s == 1 then bottom_right_layout:add(wibox.widget.systray()) end
                      bottom_right_layout:add(space)
                      bottom_right_layout:add(space)
                      bottom_right_layout:add(mylayoutbox[s])

                      bottom_layout = wibox.layout.align.horizontal()
                      bottom_layout:set_left(bottom_left_layout)
                      bottom_layout:set_middle(mytasklist[s])
                      bottom_layout:set_right(bottom_right_layout)
                      mybottomwibox[s]:set_widget(bottom_layout)

                  end

                  -- ]

                  -- [ Mouse Bindings

                  root.buttons(awful.util.table.join(
                  awful.button({ }, 4, awful.tag.viewnext),
                  awful.button({ }, 5, awful.tag.viewprev)
                  ))

                  -- ]

                  -- [ Key Bindings

                  globalkeys = awful.util.table.join(
                  awful.key({ modkey,           }, "q",   awful.tag.viewprev       ),
                  awful.key({ modkey,           }, "w",  awful.tag.viewnext       ),
                  awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
                  -- Show/Hide Wibox
                  awful.key({ modkey }, "z", function ()
                      mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible end),

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

                      -- Standard programs
                      awful.key({ altkey, "Shift"		  }, "e",   function () awful.util.spawn(manager) end),
                      awful.key({ altkey, "Shift"		  }, "f",   function () awful.util.spawn(cli_fileman) end),
                      awful.key({ altkey, "Shift"		  }, "w",   function () awful.util.spawn(browser) end),
                      awful.key({ altkey, "Shift"		  }, "t",   function () awful.util.spawn(torrent_client) end),
                      awful.key({ modkey },            "p", function ()
                          awful.util.spawn("dmenu_run -i -p 'Run command:' -nb '" .. 
                          beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. 
                          "' -sb '" .. beautiful.bg_focus .. 
                          "' -sf '" .. beautiful.fg_focus .. "'") 
                      end),
                      awful.key({ modkey,           }, "Return",function () awful.util.spawn(terminal) end),
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

                      -- Media keys
                      awful.key({            }, "XF86AudioPlay",        function () awful.util.spawn("sh /home/nir/scripts/cplay" )  end),
                      awful.key({            }, "XF86AudioNext",        function () awful.util.spawn("cmus-remote --next" )    end),
                      awful.key({            }, "XF86AudioPrev",        function () awful.util.spawn("cmus-remote --prev" )    end),
                      awful.key ({           }, "XF86AudioMute",        function () awful.util.spawn ("amixer -q  set Master toggle" ) end ),
                      awful.key ({           }, "XF86AudioLowerVolume", function () awful.util.spawn ( "amixer -q -c 0 set Master 3- unmute" ) end ),
                      awful.key ( {          }, "XF86AudioRaiseVolume", function () awful.util.spawn ( "amixer -q -c 0 set Master 3+ unmute" ) end ),
                      awful.key ( { },          "XF86AudioStop",        function () awful.util.spawn ( "cmus-remote --stop" ) end ),
                      awful.key({ },            "XF86Calculator",       function () awful.util.spawn (calc) end ),
                      awful.key({ },            "XF86HomePage",         function () awful.util.spawn (browser) end ),
                      awful.key({ },            "XF86Mail",             function () awful.util.spawn (mail) end ),
                      awful.key({ },            "XF86Documents",        function () awful.util.spawn ("thunar /home/nir/Dropbox") end ),
                      awful.key({ },            "XF86Tools",            function () awful.util.spawn ("sh /home/nir/scripts/output") end ),
                      awful.key({ },            "XF86Favorites",       function () awful.util.spawn ("sh /home/nir/scripts/composite") end ),

                      -- Move & Resize
                      awful.key({ modkey, altkey }, "Right",  function () awful.client.moveresize( 0,  0, 40, 0) end),
                      awful.key({ modkey, altkey }, "Left",   function () awful.client.moveresize( 0,  0, -40, 0) end),
                      awful.key({ modkey, altkey }, "Up",     function () awful.client.moveresize(0, 0,  0,  -40) end),
                      awful.key({ modkey, altkey }, "Down",   function () awful.client.moveresize(0, 0,  0,  40) end),
                      awful.key({ altkey },         "Down",   function () awful.client.moveresize(  0,  20,   0,   0) end),
                      awful.key({ altkey },         "Up",     function () awful.client.moveresize(  0, -20,   0,   0) end),
                      awful.key({ altkey },         "Left",   function () awful.client.moveresize(-20,   0,   0,   0) end),
                      awful.key({ altkey },         "Right",  function () awful.client.moveresize( 20,   0,   0,   0) end),

                      --  Monitor focus
                      -- 1 = DVI-I-2, left, primary
                      -- 2 = DVI-I-3, right, secondary
                      awful.key({modkey,            }, "F1", function () awful.screen.focus(1) end),
                      awful.key({modkey,            }, "F2", function () awful.screen.focus(2) end),
                      awful.key({ modkey, "Shift"   }, "F1", function (c) awful.client.movetoscreen(c, 1) end),
                      awful.key({ modkey, "Shift"   }, "F2", function (c) awful.client.movetoscreen(c, 2) end),

                      -- Scratch box
                      awful.key ( { altkey          },  "`", function() scratch.drop ( "urxvtc", "top", "center", 1.00, 0.50, true ) end ),

                      --  unminimize windows
                      awful.key({ modkey, "Shift"   }, "n",
                      function ()
                          local allclients = client.get(mouse.screen)
                          for _,c in ipairs(allclients) do
                              if c.minimized and c:tags()[mouse.screen] == awful.tag.selected(mouse.screen) then
                                  c.minimized = false
                                  client.focus = c
                                  c:raise()
                                  return
                              end
                          end
                      end),

                      -- Prompt
                      awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

                      awful.key({ modkey }, "x",
                      function ()
                          awful.prompt.run({ prompt = "Run Lua code: " },
                          mypromptbox[mouse.screen].widget,
                          awful.util.eval, nil,
                          awful.util.getdir("cache") .. "/history_eval")
                      end)
                      )

                      clientkeys = awful.util.table.join(
                      awful.key({ modkey            }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
                      awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
                      awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
                      awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
                      awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
                      awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
                      awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
                      awful.key({ modkey,           }, "n",
                      function (c)
                          c.minimized = true
                      end),
                      awful.key({ modkey,           }, "m",
                      function (c)
                          c.maximized_horizontal = not c.maximized_horizontal
                          c.maximized_vertical   = not c.maximized_vertical
                      end)
                      )

                      keynumber = 0
                      for s = 1, screen.count() do
                          keynumber = math.min(9, math.max(#tags[s], keynumber));
                      end

                      for i = 1, keynumber do
                          globalkeys = awful.util.table.join(globalkeys,
                          awful.key({ modkey }, "#" .. i + 9,
                          function ()
                              screen = mouse.screen
                              if tags[screen][i] then
                                  awful.tag.viewonly(tags[screen][i])
                              end
                          end),
                          awful.key({ modkey, "Control" }, "#" .. i + 9,
                          function ()
                              screen = mouse.screen
                              if tags[screen][i] then
                                  awful.tag.viewtoggle(tags[screen][i])
                              end
                          end),
                          awful.key({ modkey, "Shift" }, "#" .. i + 9,
                          function ()
                              if client.focus and tags[client.focus.screen][i] then
                                  awful.client.movetotag(tags[client.focus.screen][i])
                              end
                          end),
                          awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                          function ()
                              if client.focus and tags[client.focus.screen][i] then
                                  awful.client.toggletag(tags[client.focus.screen][i])
                              end
                          end))
                      end

                      clientbuttons = awful.util.table.join(
                      awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
                      awful.button({ modkey }, 1, awful.mouse.client.move),
                      awful.button({ modkey }, 3, awful.mouse.client.resize))

                      -- Set keys
                      root.keys(globalkeys)

                      -- ]

                      -- [ Rules

                      awful.rules.rules = {
                          -- All clients will match this rule.
                          { rule = { },
                          properties = { border_width = beautiful.border_width,
                          border_color = beautiful.border_normal,
                          focus = true,
                          keys = clientkeys,
                          maximized_vertical = false,
                          maximized_horizontal = false,
                          buttons = clientbuttons,
                          size_hints_honor = false } },

                          { rule = { instance = "plugin-container" },
                          properties = { floating = true } },


                          { rule = { class = "mpv" },
                          properties = { floating = true  } },

                      }


                      -- ]

                      -- [ Signals

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

                          local titlebars_enabled = false
                          if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
                              -- Widgets that are aligned to the left
                              local left_layout = wibox.layout.fixed.horizontal()
                              left_layout:add(awful.titlebar.widget.iconwidget(c))

                              -- Widgets that are aligned to the right
                              local right_layout = wibox.layout.fixed.horizontal()
                              right_layout:add(awful.titlebar.widget.floatingbutton(c))
                              right_layout:add(awful.titlebar.widget.maximizedbutton(c))
                              right_layout:add(awful.titlebar.widget.stickybutton(c))
                              right_layout:add(awful.titlebar.widget.ontopbutton(c))
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

                      -- ]
