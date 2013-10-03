export PANEL_FIFO=/tmp/panel-fifo
export PANEL_HEIGHT=18
export BSPWM_SOCKET=/tmp/bspwm-socket

 #[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

 if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi



