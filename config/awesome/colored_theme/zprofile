if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    #exec nohup startx > .xlog & vlock
    #exec startx
    exec xinit -- /usr/bin/X -nolisten tcp vt7
fi
