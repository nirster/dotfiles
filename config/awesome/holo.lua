--[[                                  ]]--
--                                      -
--     Holo Awesome WM 3.5.+ config     --
--      github.com/copycat-killer       --
--                                      -
--[[                                  ]]--


-- {{{ Required Libraries

local gears           = require("gears")
local awful           = require("awful")
awful.rules           = require("awful.rules")
awful.autofocus       = require("awful.autofocus")
local wibox           = require("wibox")
local beautiful       = require("beautiful")
local naughty         = require("naughty")
local vicious         = require("vicious")
local scratch         = require("scratch")
local yawn            = require("yawn")
local layouts         = require("layouts")

-- }}}

-- {{{ Autostart applications

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end


-- }}}

-- {{{ Localization

os.setlocale(os.getenv("LANG"))

-- }}}

-- {{{ Error Handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
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
        local in_error = false
    end)
end

-- }}}

-- {{{ Global variables

home = os.getenv("HOME")
confdir = home .. "/.config/awesome"
scriptdir = confdir .. "/scripts/"
themes = confdir .. "/themes"
active_theme = themes .. "/holo"
language = string.gsub(os.getenv("LANG"), ".utf8", "")

beautiful.init(active_theme .. "/theme.lua")

terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
gui_editor = "gvim"
browser = "google-chrome"
calc = "galculator"
mail = "google-chrome www.gmail.com"
wifi = terminal .. " -e sudo wifi-menu "
musicplr = terminal .. " -g 130x34-320+16 -e ncmpcpp "
fileman = "thunar " .. home
manager = "thunar "

modkey = "Mod4"
altkey = "Mod1"
control= "Control"
shift  = "Shift"

layouts =
{
    awful.layout.suit.floating,             -- 1
    awful.layout.suit.tile,                 -- 2
    awful.layout.suit.fair,                 -- 3
    awful.layout.suit.tile.left,            -- 4
    awful.layout.suit.tile.top,             -- 5
    layouts.tilegaps,                       -- 6
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

tags = {
       names = { " WEB ", " TERMINAL ", " FILES ", " OTHER " },
       layout = { layouts[1], layouts[3], layouts[2], layouts[4] }
       }
for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
end

-- }}}

-- {{{ Menu

myaccessories = {
   { "archives", "7zFM" },
   { "charmap", "gucharmap" },
   { "gbdfed", "gbdfed" },
   { "gimp", "gimp" },
   { "text editor", gui_editor },
}
myinternet = {
    { "torrent" , "transmission-gtk" },
    { "torrent search" , "torrent-search" }
}
myoffice = {
    { "writer" , "lowriter" },
    { "impress" , "loimpress" },
}
mysystem = {
    { "appearance" , "lxappearance" },
    { "cleaning" , "bleachbit" },
    { "powertop" , terminal .. " -e sudo powertop " },
}
mymainmenu = awful.menu({ items = {
				    { "accessories" , myaccessories },
				    { "internet" , myinternet },
				    { "office" , myoffice },
				    { "system" , mysystem },
            }
            })
mylauncher = awful.widget.launcher({ menu = mymainmenu })

-- }}}

-- {{{ Wibox

local util = awful.util

-- Colours
coldef  = "</span>"
white  = "<span color='#FFFFFF'>"
blue = "<span color='#80CCE6'>"
space = "<span font='Tamsyn 3'> </span>"

-- Menu widget
awesome_icon = wibox.widget.imagebox()
awesome_icon:set_image(beautiful.awesome_icon)
awesome_icon:buttons(util.table.join( awful.button({ }, 1, function() mymainmenu:toggle() end)))

-- Clock widget
mytextclock = awful.widget.textclock(white .. space .. "%H:%M<span font='Tamsyn 2'> </span>" .. coldef)
clock_icon = wibox.widget.imagebox()
clock_icon:set_image(beautiful.clock)
clockwidget = wibox.widget.background()
clockwidget:set_widget(mytextclock)
clockwidget:set_bgimage(beautiful.widget_bg)

-- Calendar widget
mytextcalendar = awful.widget.textclock(white .. space .. "%d %B<span font='Tamsyn 5'> </span>" .. coldef)
calendar_icon = wibox.widget.imagebox()
calendar_icon:set_image(beautiful.calendar)
calendarwidget = wibox.widget.background()
calendarwidget:set_widget(mytextcalendar)
calendarwidget:set_bgimage(beautiful.widget_bg)

-- Calendar notification
local tonumber = tonumber
local calendar = nil
local offset = 0

function remove_calendar()
   if calendar ~= nil then
      naughty.destroy(calendar)
      calendar = nil
   end
end

function show_calendar(inc_offset, t_out)
   remove_calendar()
   local f, c_text
   local today = tonumber(os.date('%d'))

   if inc_offset == 0 then
       if today < 10 then
           f = io.popen('/usr/bin/cal | sed -r -e "s/(^| )( ' .. today .. ')($| )/\\1<b><span foreground=\\"#242424\\" background=\\"#FFFFFF\\">\\2<\\/span><\\/b>\\3/"',"r")
       else
           f = io.popen('/usr/bin/cal | sed -r -e "s/(^| )(' .. today .. ')($| )/\\1<b><span foreground=\\"#242424\\" background=\\"#FFFFFF\\">\\2<\\/span><\\/b>\\3/"',"r")
       end
       c_text = "<tt><span font='Tamsyn 12'><b>" .. f:read() .. "</b>\n\n" .. f:read() .. "\n" .. f:read("*all") .. "</span></tt>"
       f:close()
       offset = 0
   else
       local month = tonumber(os.date('%m'))
       local year = tonumber(os.date('%Y'))

       offset = offset + inc_offset 
       month = month + offset

       if month > 12 then
           month = 12
           offset = 12 - tonumber(os.date('%m')) 
       elseif month < 1 then
           month = 1
           offset = 1 - tonumber(os.date('%m'))
       end
                       
       f = io.popen('/usr/bin/cal ' .. month .. ' ' .. year ,"r")
       c_text = "<tt><span font='Tamsyn 12'><b>" .. f:read() .. "</b>\n\n" .. f:read() .. "\n" .. f:read("*all") .. "</span></tt>"
       f:close()
   end

   calendar = naughty.notify({ text = c_text,
                               position = "bottom_right", 
                               fg = beautiful.fg_normal,
                               bg = beautiful.bg_normal,
                               timeout = t_out 
                            })
end

calendarwidget:connect_signal("mouse::enter", function() show_calendar(0, 0) end)
calendarwidget:connect_signal("mouse::leave", function() remove_calendar() end)
calendarwidget:buttons(util.table.join( awful.button({ }, 1, function() show_calendar(-1, 0) end),
                                     awful.button({ }, 3, function() show_calendar(1, 0) end)))

-- GMail widget
mygmail = wibox.widget.textbox()
gmail_t = awful.tooltip({ objects = { mygmail },})
notify_shown = false
mailcount = 0
vicious.register(mygmail, vicious.widgets.gmail,
 function (widget, args)
  gmail_t:set_text(args["{subject}"])
  gmail_t:add_to_object(mygmail)
  notify_title = ""
  notify_text = ""
  mailcount = args["{count}"]
  if (args["{count}"] > 0 ) then
    if (notify_shown == false) then
      -- Italian localization
      -- can be a stub for your own localization
      if (args["{count}"] == 1) then
          if language:find("it_IT") ~= nil
          then
              notify_title = "Hai un nuovo messaggio"
          else
              notify_title = "You've got a new mail"
          end
          notify_text = '"' .. args["{subject}"] .. '"'
      else
          if language:find("it_IT") ~= nil
          then
                notify_title = "Hai " .. args["{count}"] .. " nuovi messaggi"
                notify_text = 'Ultimo: "' .. args["{subject}"] .. '"'
          else
                notify_title = "You've got " .. args["{count}"] .. " new mails"
                notify_text = 'Last one: "' .. args["{subject}"] .. '"'
          end
      end
      naughty.notify({
          title = notify_title,
          text = notify_text,
          timeout = 7,
          position = "top_left",
          icon = beautiful.widget_mail_notify,
          fg = fg_normal,
          bg = bg_normal 
      })
      notify_shown = true
    end
    return white .. " Mail " .. coldef .. blue .. args["{count}"] .. " " .. coldef 
  else
    notify_shown = false
    return ''
  end
end, 60)
mygmail:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(mail, false) end)))

-- Cmus widget
cmuswidget = wibox.widget.textbox()
mpd_icon = wibox.widget.imagebox()
mpd_icon:set_image(beautiful.mpd)
prev_icon = wibox.widget.imagebox()
prev_icon:set_image(beautiful.prev)
next_icon = wibox.widget.imagebox()
next_icon:set_image(beautiful.nex)
stop_icon = wibox.widget.imagebox()
stop_icon:set_image(beautiful.stop)
pause_icon = wibox.widget.imagebox()
pause_icon:set_image(beautiful.pause)
play_pause_icon = wibox.widget.imagebox()
play_pause_icon:set_image(beautiful.play)
curr_track = nil
vicious.register(cmuswidget, vicious.widgets.cmus,
function(widget, args)
	if args["{state}"] == "Play" then
    if args["{Title}"] ~= curr_track
     then
        curr_track = args["{Title}"]
        os.execute(scriptdir .. "mpdinfo")
        old_id = naughty.notify({
            title = "Now playing",
            text = args["{Artist}"] .. " (" .. args["{Album}"] .. ")\n" .. args["{Title}"],
            icon = "/tmp/mpdnotify_cover.png",
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            timeout = 5,
            replaces_id = old_id
        }).id
    end
    mpd_icon:set_image(beautiful.mpd_on)
    play_pause_icon:set_image(beautiful.pause)
    return blue  .. "<span font='Tamsyn 1'> </span>" .. args["{Title}"] .. coldef .. white .. " " .. args["{Artist}"] .. coldef .. " " 
	 elseif args["{state}"] == "Pause" then
    mpd_icon:set_image(beautiful.mpd)
    play_pause_icon:set_image(beautiful.play)

    -- Italian localization
    -- can be a stub for your own localization
    if language:find("it_IT") ~= nil then
        return blue .. "<span font='Tamsyn 2'> </span>mpd " .. coldef .. white .. "in pausa " .. coldef
    else
        return blue .. "<span font='Tamsyn 2'> </span>cmus " .. coldef .. white .. "paused " .. coldef
    end
	else
    mpd_icon:set_image(beautiful.mpd)
    curr_track = nil
		return "<span font='Tamsyn 3'> </span>"
	end
end, 1)

musicwidget = wibox.widget.background()
musicwidget:set_widget(cmuswidget)
musicwidget:set_bgimage(beautiful.widget_bg)
musicwidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
mpd_icon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
prev_icon:buttons(awful.util.table.join(awful.button({}, 1, function ()
                                                                awful.util.spawn( "cmus-remote --prev", false )
                                                                vicious.force({ cmuswidget } )
                                                             end)))
next_icon:buttons(awful.util.table.join(awful.button({}, 1, function ()
                                                                awful.util.spawn( "cmus-remote --next", false )
                                                                vicious.force({ cmuswidget } )
                                                             end)))
stop_icon:buttons(awful.util.table.join(awful.button({}, 1, function ()
                                                                play_pause_icon:set_image(beautiful.play)
                                                                awful.util.spawn( "cmus-remote --stop", false )
                                                                vicious.force({ cmuswidget } )
                                                             end)))
play_pause_icon:buttons(awful.util.table.join(awful.button({}, 1, function ()
                                                                awful.util.spawn( "sh /home/nir/scripts/cplay", false )
                                                                vicious.force({ cmuswidget } )
                                                             end)))

-- /home fs widget
fshwidget = wibox.widget.textbox()
too_much = false
vicious.register(fshwidget, vicious.widgets.fs,
function (widget, args)
  if ( args["{/home used_p}"] >= 90 ) then
      if ( args["{/home used_p}"] >= 99 and too_much == false ) then
        naughty.notify({ title = "Warning", text = "Partition /home is almost full.",
        timeout = 7,
        position = "top_right",
        fg = beautiful.fg_urgent,
        bg = beautiful.bg_urgent })
        too_much = true
      end
      return white .. " Hdd " .. coldef .. blue .. args["{/home used_p}"] .. coldef .. " "
  else
    return ""
  end
end, 600)

-- hhd status notification
local infos = nil

function remove_info()
    if infos ~= nil then
        naughty.destroy(infos)
        infos = nil
    end
end

function show_info(t_out)
    remove_info()
    local capi = {
		mouse = mouse,
		screen = screen
	  }
    local hdd = awful.util.pread(scriptdir .. "dfs")
    hdd = string.gsub(hdd, "          ^%s*(.-)%s*$", "%1")

    -- Italian localization
    -- can be a stub for your own localization
    if language:find("it_IT") ~= nil
    then
        hdd = string.gsub(hdd, "Used ", "Usato")
        hdd = string.gsub(hdd, "Free  ", "Libero")
        hdd = string.gsub(hdd, "Total ", "Totale")
    end

    infos = naughty.notify({
        text = hdd,
      	timeout = t_out,
        position = "top_right",
        margin = 10,
        height = 210,
        width = 680,
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
		    screen = capi.mouse.screen
    })
end

fshwidget:connect_signal('mouse::enter', function () show_info(0) end)
fshwidget:connect_signal('mouse::leave', function () remove_info() end)

-- Battery widget
batwidget = wibox.widget.textbox()
function batstate()

  local file = io.open("/sys/class/power_supply/BAT0/status", "r")

  if (file == nil) then
    return "Cable plugged"
  end

  local batstate = file:read("*line")
  file:close()

  if (batstate == 'Discharging' or batstate == 'Charging') then
    return batstate
  else
    return "Fully charged"
  end
end
vicious.register(batwidget, vicious.widgets.bat,
function (widget, args)
  -- plugged
  if (batstate() == 'Cable plugged' or batstate() == 'Unknown') then
    return ''
    -- critical
  elseif (args[2] <= 5 and batstate() == 'Discharging') then
    naughty.notify{
      text = "Shutdown imminent...",
      title = "Battery almost off!",
      position = "top_right",
      timeout = 0,
      fg="#000000",
      bg="#ffffff",
      screen = 1,
      ontop = true,
    }
    -- low
  elseif (args[2] <= 10 and batstate() == 'Discharging') then
    naughty.notify({
      text = "Plug the cable!",
      title = "Low battery",
      position = "top_right",
      timeout = 0,
      fg="#ffffff",
      bg="#262729",
      screen = 1,
      ontop = true,
    })
  end
  return blue .. "Bat " .. coldef .. white .. args[2] .. " " .. coldef
end, 1, 'BAT0')

-- {{{ Volume widget
--
-- original version: http://awesome.naquadah.org/wiki/Rman%27s_Simple_Volume_Widget

local alsawidget =
{
	channel = "Master",
	step = "5%",
	colors =
	{
		unmute = "#80CCE6",
		mute = "#FF9F9F"
	},
	mixer = terminal .. " -e alsamixer", -- or whatever your preferred sound mixer is
	notifications =
  { 
    font = "Tamsyn 12",
    bar_size = 32
  }
}

alsawidget.bar = awful.widget.progressbar ()
alsawidget.bar:set_width (80)
alsawidget.bar:set_height (10)
awful.widget.progressbar.set_ticks (alsawidget.bar, true)
alsamargin = wibox.layout.margin (alsawidget.bar, 5, 8, 80)
wibox.layout.margin.set_top (alsamargin, 12)
wibox.layout.margin.set_bottom (alsamargin, 12)
volumewidget = wibox.widget.background()
volumewidget:set_widget(alsamargin)
volumewidget:set_bgimage(beautiful.widget_bg)


alsawidget.bar:set_background_color ("#595959")
alsawidget.bar:set_color (alsawidget.colors.unmute)
alsawidget.bar:buttons (awful.util.table.join (
	awful.button ({}, 1, function()
		awful.util.spawn (alsawidget.mixer)
	end),
	awful.button ({}, 3, function()
		awful.util.spawn ("amixer sset " .. alsawidget.channel .. " toggle")
		vicious.force ({ alsawidget.bar })
	end),
	awful.button ({}, 4, function()
		awful.util.spawn ("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "+")
		vicious.force ({ alsawidget.bar })
	end),
	awful.button ({}, 5, function()
		awful.util.spawn ("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "-")
		vicious.force ({ alsawidget.bar })
	end)
))

-- tooltip
alsawidget.tooltip = awful.tooltip ({ objects = { alsawidget.bar } })

-- naughty notifications
alsawidget._current_level = 0
alsawidget._muted = false

function alsawidget:notify ()
	local preset =
	{
    --   title = "", text = "",
    timeout = 3,
		height = 40,
		width = 285,
		font = alsawidget.notifications.font,
    fg = "#EEE5E5",
    bg = "#222222"
	}

	if alsawidget._muted
  then
		preset.title = alsawidget.channel .. " - Muted"
	else
		preset.title = alsawidget.channel .. " - " .. alsawidget._current_level .. "%"
	end

  local int = math.modf (alsawidget._current_level / 100 * alsawidget.notifications.bar_size)
  preset.text = "[" .. string.rep ("|", int) .. string.rep (" ", alsawidget.notifications.bar_size - int) .. "]"
	
  if alsawidget._notify ~= nil
  then
		alsawidget._notify = naughty.notify (
		{
			replaces_id = alsawidget._notify.id,
			preset = preset
		})
	else
		alsawidget._notify = naughty.notify ({ preset = preset })
	end
end

-- register the widget through vicious
vicious.register (alsawidget.bar, vicious.widgets.volume, function (widget, args)
	alsawidget._current_level = args[1]
	if args[2] ~= "♩"
	then
	  alsawidget._muted = false
 	  alsawidget.tooltip:set_text (" " .. alsawidget.channel .. ": " .. args[1] .. "% ")
	  widget:set_color (alsawidget.colors.unmute)
  else
		alsawidget._muted = true
		alsawidget.tooltip:set_text (" [Muted] ")
		widget:set_color (alsawidget.colors.mute)
  end
  return args[1]
end, 5, alsawidget.channel) -- relatively high update time, use of keys/mouse will force update

-- }}}

-- CPU widget
cpu_widget = wibox.widget.textbox()
vicious.register(cpu_widget, vicious.widgets.cpu, white .. space .. "CPU $1%<span font='Tamsyn 5'> </span>" .. coldef, 3)
cpuwidget = wibox.widget.background()
cpuwidget:set_widget(cpu_widget)
cpuwidget:set_bgimage(beautiful.widget_bg)
cpu_icon = wibox.widget.imagebox()
cpu_icon:set_image(beautiful.cpu)

-- Wifi widget
netdown_icon = wibox.widget.imagebox()
netdown_icon:set_image(beautiful.net_down)
netup_icon = wibox.widget.imagebox()
netup_icon:set_image(beautiful.net_up)
no_net_shown = true
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net,
function (widget, args)
    if args["{wlan0 carrier}"] == 0 then
       if no_net_shown == true then
         naughty.notify({ title = "wlan0", text = "No carrier",
         timeout = 7,
         position = "top_left",
         icon = beautiful.widget_no_net_notify,
         fg = "#FF1919",
         bg = beautiful.bg_normal })
         no_net_shown = false
         netdown_icon:set_image()
         netup_icon:set_image()
       end
       return white .. "<span font='Tamsyn 2'> </span>Net " .. coldef .. "<span color='#FF4040'>Off<span font='Tamsyn 5'> </span>"  .. coldef
    else
       if no_net_shown ~= true then
         netdown_icon:set_image(beautiful.net_down)
         netup_icon:set_image(beautiful.net_up)
         no_net_shown = true
       end
       return white .. "<span font='Tamsyn 2'> </span>" .. args["{eth0 down_kb}"] .. " - " .. args["{eth0 up_kb}"] .. "<span font='Tamsyn 2'> </span>" .. coldef
    end
end, 3)
networkwidget = wibox.widget.background()
networkwidget:set_widget(netwidget)
networkwidget:set_bgimage(beautiful.widget_bg)
networkwidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(wifi) end)))

-- Weather widget
yawn.register(1968179) -- https//github.com/copycat-killer/yawn

-- Separators
first = wibox.widget.textbox('<span font="Tamsyn 4"> </span>')
last = wibox.widget.imagebox()
last:set_image(beautiful.last)
spr = wibox.widget.imagebox()
spr:set_image(beautiful.spr)
spr_small = wibox.widget.imagebox()
spr_small:set_image(beautiful.spr_small)
spr_very_small = wibox.widget.imagebox()
spr_very_small:set_image(beautiful.spr_very_small)
spr_right = wibox.widget.imagebox()
spr_right:set_image(beautiful.spr_right)
spr_bottom_right = wibox.widget.imagebox()
spr_bottom_right:set_image(beautiful.spr_bottom_right)
spr_left = wibox.widget.imagebox()
spr_left:set_image(beautiful.spr_left)
bar = wibox.widget.imagebox()
bar:set_image(beautiful.bar)
bottom_bar = wibox.widget.imagebox()
bottom_bar:set_image(beautiful.bottom_bar)

-- }}}

-- {{{ Layout

-- Create a wibox for each screen and add it
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
    mypromptbox[s] = awful.widget.prompt()
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
    
    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 32 })

    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(first)
    left_layout:add(mytaglist[s])
    left_layout:add(spr_small)
    left_layout:add(mylayoutbox[s])

    -- Widgets that are aligned to the upper right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mygmail)
    right_layout:add(fshwidget)
    --right_layout:add(batwidget)
    right_layout:add(spr_right)
    right_layout:add(prev_icon)
    right_layout:add(next_icon)
    right_layout:add(stop_icon)
    right_layout:add(play_pause_icon)
    right_layout:add(bar)
    right_layout:add(mpd_icon)
    right_layout:add(musicwidget)
    right_layout:add(bar)
    right_layout:add(spr_very_small)
    right_layout:add(volumewidget)
    right_layout:add(spr_left)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

    -- Create the bottom wibox
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = 32 })
            
    -- Widgets that are aligned to the bottom left
    bottom_left_layout = wibox.layout.fixed.horizontal()
    bottom_left_layout:add(awesome_icon)
                        
    -- Widgets that are aligned to the bottom right
    bottom_right_layout = wibox.layout.fixed.horizontal()
    bottom_right_layout:add(spr_bottom_right)
    bottom_right_layout:add(netdown_icon)
    bottom_right_layout:add(networkwidget)
    bottom_right_layout:add(netup_icon)
    bottom_right_layout:add(bottom_bar)
    bottom_right_layout:add(cpu_icon)
    bottom_right_layout:add(cpuwidget)
    bottom_right_layout:add(bottom_bar)
    bottom_right_layout:add(calendar_icon)
    bottom_right_layout:add(calendarwidget)
    bottom_right_layout:add(bottom_bar)
    bottom_right_layout:add(clock_icon)
    bottom_right_layout:add(clockwidget)
    bottom_right_layout:add(last)
                                            
    -- Now bring it all together (with the tasklist in the middle)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
    bottom_layout:set_middle(mytasklist[s])
    bottom_layout:set_right(bottom_right_layout)
    mybottomwibox[s]:set_widget(bottom_layout)

    -- Set proper backgrounds, instead of beautiful.bg_normal
    mywibox[s]:set_bg(beautiful.bg_normal_png)
    mybottomwibox[s]:set_bg("#242424")
end

-- }}}

-- {{{ Mouse Bindings

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- }}}

-- {{{ Key bindings

globalkeys = awful.util.table.join(

    -- Capture a screenshot
    --awful.key({ altkey }, "p", function() awful.util.spawn("screenshot", false) end),

    -- Move clients
    --awful.key({ altkey }, "Next",  function () awful.client.moveresize( 1,  1, -2, -2) end),
    --awful.key({ altkey }, "Prior", function () awful.client.moveresize(-1, -1,  2,  2) end),
    --awful.key({ altkey }, "Down",  function () awful.client.moveresize(  0,  1,   0,   0) end),
    --awful.key({ altkey }, "Up",    function () awful.client.moveresize(  0, -1,   0,   0) end),
    --awful.key({ altkey }, "Left",  function () awful.client.moveresize(-1,   0,   0,   0) end),
    --awful.key({ altkey }, "Right", function () awful.client.moveresize( 1,   0,   0,   0) end),
    awful.key({ modkey,           }, "q",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "e",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
        mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible
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

        -- Move & Resize
        awful.key({ modkey, altkey }, "Right",  function () awful.client.moveresize( 0,  0, 40, 0) end),
        awful.key({ modkey, altkey }, "Left",   function () awful.client.moveresize( 0,  0, -40, 0) end),
        awful.key({ modkey, altkey }, "Up",     function () awful.client.moveresize(0, 0,  0,  -40) end),
        awful.key({ modkey, altkey }, "Down",   function () awful.client.moveresize(0, 0,  0,  40) end),
        awful.key({ altkey },         "Down",   function () awful.client.moveresize(  0,  20,   0,   0) end),
        awful.key({ altkey },         "Up",     function () awful.client.moveresize(  0, -20,   0,   0) end),
        awful.key({ altkey },         "Left",   function () awful.client.moveresize(-20,   0,   0,   0) end),
        awful.key({ altkey },         "Right",  function () awful.client.moveresize( 20,   0,   0,   0) end),

    -- Standard program
    awful.key({ altkey , "Shift"		  } , "e"      , function () awful.util.spawn(manager) end)        ,
    awful.key({ altkey , "Shift"		  } , "f"      , function () awful.util.spawn(cli_fileman) end)    ,
    awful.key({ altkey , "Shift"		  } , "w"      , function () awful.util.spawn(browser) end)        ,
    awful.key({ altkey , "Shift"		  } , "t"      , function () awful.util.spawn(torrent_client) end) ,
    awful.key({ modkey , }               , "Return" , function () awful.util.spawn(terminal) end)       ,
    awful.key({ modkey , "Control" }     , "r"      , awesome.restart)                                  ,
    awful.key({ modkey , "Shift"   }     , "q"      , awesome.quit)                                     ,
    awful.key({ modkey , }               , "l"      , function () awful.tag.incmwfact( 0.05)     end)   ,
    awful.key({ modkey , }               , "h"      , function () awful.tag.incmwfact(-0.05)     end)   ,
    awful.key({ modkey , "Shift"   }     , "h"      , function () awful.tag.incnmaster( 1)       end)   ,
    awful.key({ modkey , "Shift"   }     , "l"      , function () awful.tag.incnmaster(-1)       end)   ,
    awful.key({ modkey , "Control" }     , "h"      , function () awful.tag.incncol( 1)          end)   ,
    awful.key({ modkey , "Control" }     , "l"      , function () awful.tag.incncol(-1)          end)   ,
    awful.key({ modkey , }               , "space"  , function () awful.layout.inc(layouts              , 1)  end)  ,
    awful.key({ modkey , "Shift"   }     , "space"  , function () awful.layout.inc(layouts              , -1)  end) ,
    awful.key({ modkey , "Control" }     , "n"      , awful.client.restore)                             ,

    -- Media keys
    awful.key({            }, "XF86AudioPlay",        function () awful.util.spawn("sh /home/nir/scripts/cplay" )  
                                                                  vicious.force({ cmuswidget } )
                                                      end),

    awful.key({            }, "XF86AudioNext",        function () awful.util.spawn("cmus-remote --next" )
                                                                  vicious.force({ cmuswidget } )
                                                      end),

    awful.key({            }, "XF86AudioPrev",        function () awful.util.spawn("cmus-remote --prev" ) 
                                                                  vicious.force({ cmuswidget } )
                                                      end),

    awful.key ({           }, "XF86AudioMute",        function () awful.util.spawn ("amixer -q  set Master toggle" )
                                                                  vicious.force({ alsawidget.bar })
                                                                  alsawidget.notify() 
                                                      end ),

    awful.key ({           }, "XF86AudioLowerVolume", function () awful.util.spawn ( "amixer -q -c 0 set Master 3- unmute" ) 
                                                                  vicious.force({ alsawidget.bar }) 
                                                                  alsawidget.notify() 
                                                      end ),

    awful.key ( {          }, "XF86AudioRaiseVolume", function () awful.util.spawn ( "amixer -q -c 0 set Master 3+ unmute" ) 
                                                                  vicious.force({ alsawidget.bar })
                                                                  alsawidget.notify() 
                                                      end ),

    awful.key ( { },          "XF86AudioStop",        function () awful.util.spawn ( "cmus-remote --stop" )
                                                                  vicious.force( {cmuswidget} )
                                                      end ),

    awful.key({ },            "XF86Calculator",       function () awful.util.spawn (calc) end ),
    awful.key({ },            "XF86HomePage",         function () awful.util.spawn (browser) end ),
    awful.key({ },            "XF86Mail",             function () awful.util.spawn (mail) end ),
    awful.key({ },            "XF86Documents",        function () awful.util.spawn ("thunar /home/nir/Dropbox") end ),
    awful.key({ },            "XF86Tools",            function () awful.util.spawn ("sh /home/nir/scripts/output") end ),
    awful.key({ },            "XF86Favorites",       function () awful.util.spawn ("sh /home/nir/scripts/composite") end ),
    
    --  Monitor focus
    -- 1 = DVI-I-2, left, primary
    -- 2 = DVI-I-3, right, secondary
    awful.key({modkey,            }, "F1", function () awful.screen.focus(1) end),
    awful.key({modkey,            }, "F2", function () awful.screen.focus(2) end),
    awful.key({ modkey, "Shift"   }, "F1", function (c) awful.client.movetoscreen(c, 1) end),
    awful.key({ modkey, "Shift"   }, "F2", function (c) awful.client.movetoscreen(c, 2) end),

    -- dmenu
    awful.key({ modkey },            "p", function ()
        awful.util.spawn("dmenu_run -i -p 'Run command:' -nb '" .. 
        beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. 
        "' -sb '" .. beautiful.bg_focus .. 
        "' -sf '" .. beautiful.fg_focus .. "'") 
    end),
    
    -- Dropdown terminal
    awful.key({ altkey,	          }, "`",      function () scratch.drop(terminal) end),

    -- Widgets popups
    awful.key({ altkey,           }, "c",      function () show_calendar(0, 7) end),
    awful.key({ altkey,           }, "h",      function ()
                                                  vicious.force({ fshwidget })
                                                  show_info(7)
                                               end),
    awful.key({ altkey,           }, "w",      function () yawn.show_weather(5) end),

    -- Copy to clipboard
    awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
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

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
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

-- }}}

-- {{{ Rules

awful.rules.rules = {
     -- All clients will match this rule.
     { rule = { },
       properties = { border_width = beautiful.border_width,
                      border_color = beautiful.border_normal,
                      focus = awful.client.focus.filter,
                      keys = clientkeys,
                      buttons = clientbuttons,
	                    size_hints_honor = false
                     }
    },

                          { rule = { instance = "plugin-container" },
                          properties = { floating = true } },


                          { rule = { class = "mpv" },
                          properties = { floating = true  } },

                          { rule = { class = "galculator" },
                          properties = { floating = true  } },

                          { rule = { class = "squeeze" },
                          properties = { floating = true  } },
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

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
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
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_width = "0"
            c.border_color = beautiful.border_normal
        else
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}

-- {{{ Arrange signal handler

for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))
    
        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width
    
                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    clients[1].border_width = 0
                    awful.client.moveresize(0, 0, 2, 2, clients[1])
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
