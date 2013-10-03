#!/bin/bash

# Fonts and settings
xset +fp /usr/share/fonts/local
xset +fp /usr/share/fonts/artwiz-fonts
xset +fp /usr/share/fonts/TTF
xset +fp /usr/share/fonts/misc
xset fp rehash
xrdb -merge ~/.Xresources

# Align monitors
xrandr --output DVI-I-3 --mode 1920x1200 --right-of DVI-I-2 &
xrandr --output DVI-I-2 --primary &

# Java GUI fix
wmname LG3D &

# Nvidia settings
nvidia-settings --load-config-only &
nvidia-settings -a InitialPixmapPlacement=2 &

# Map Caps-Lock to Escape
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape' &

# Activate numlock
numlockx &

# Enable killing the X server
setxkbmap -option terminate:ctrl_alt_bksp

# Wallpaper
nitrogen --restore &
# X mouse cursor
xsetroot -cursor_name left_ptr &
# hide cursor when inactive
unclutter -noevents -root &

# Compositor
compton --backend glx --vsync opengl --paint-on-overlay &

#udiskie &
#thunar --daemon &
#dropboxd &
start-pulseaudio-x11 &
mpd ~/.mpdconf &
# Start Window Manager
exec awesome 


#[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
#mkfifo "$PANEL_FIFO"
#sxhkd &
#exec bspwm -s "$PANEL_FIFO" -p -W
