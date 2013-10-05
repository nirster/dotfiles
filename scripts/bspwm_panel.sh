#!/bin/sh
#
# NethRaiden's bspwm panel
# 

#
# Config
#
VOLUP="amixer -q sset Master 1.50dB+"
VOLDOWN="amixer -q sset Master 1.50dB-"
PLAYER="termite -e ncmpcpp"

FONT_FAMILY="Terminus"
FONT_SIZE="11"
FONT_PIXEL="7"  # pixel width of characted - calculated using e.g. txtw-git
SCREEN_WIDTH=3840

BG="#010101"
FG="#fff"
RED="#f92672"
GREEN="#82b414"
ORANGE="#fd971f"
BLUE="#8c54fe"
#
# /Config
#

# Prepare some system info and send to bspwm fifo
while true
do
    # Date and time
    clock="$(date "+%e.%m %R")"

    # Free RAM
    mem="$(free -h | grep 'buffers/cache' | awk '{print $3}')"

    # WLAN signal power
    iwconfig="$(iwconfig wlp6s2)"
    signal="$(echo $iwconfig | grep Signal | awk '{print $28 $29}' | sed 's/level=//g; s/ //g')"
    if [[ "$signal" == "" ]]; then
        wlan="down"
    else
        wlan="$(echo $iwconfig | grep ESSID | sed 's/.*ESSID\:"//g; s/".*//g') $signal"
    fi

    # Master volume
    vol="$(amixer get Master | grep -F '[on]' | awk '{print $5}' | tr -d '[]')"
    [[ "$vol" == "" ]] && vol="mute"

    # mpd
    mpd="$(mpc current)"
    [[ "$mpd" == "" ]] && mpd="stopped"

    echo "S"\
        "^ca(1,$PLAYER)^fg($RED).mpd $mpd ^fg()^ca()"\
        "^ca(4,$VOLUP)^ca(5,$VOLDOWN)^fg($GREEN) .vol $vol ^fg()^ca()^ca()"\
        "^fg($BLUE) .mem $mem ^fg()"\
        "^fg($ORANGE) .wlan $wlan ^fg()"\
        " |  $clock"
    sleep 2
done > $BSPWM_FIFO &

pid=$!
trap "kill $pid; exit" SIGHUP SIGINT SIGTERM

# Format data from bspwm fifo and send it to dzen
oldifs="$IFS"
tags=""
info=""
while read -r input <$BSPWM_FIFO
do
    case $input in
        M*)	# Tags processing
            IFS=":"
            tags=""
            set -- ${input?#}
            while [ $# -gt 0 ];
            do
                item=$1
                case $item in
                    [OoFfUu]*)
                        name=${item#?}
                        disp_name=$name
                        color=""
                        case $item in
                            [OFU]*) # Focused desktop
                                color="$GREEN"
                                disp_name="."$name"."
                                ;;
                            o*) # occupied
                                color="$ORANGE"
                                disp_name=$name
                                ;;
                        esac
                        tags="$tags ^fg($color)^ca(1,bspc desktop -f $name)$disp_name^ca()"
                        ;;
                esac
                shift
            done
            IFS=$oldifs
            ;;
        S*)	# Info processing-not-so-much
            info=${input#?}
            ;;
    esac
    #info_width=$(txtw -f "$FONT_FAMILY" -s 11 "$(echo "$info." | sed "s/\^[a-z]\+([^)]*)//g")")
    info_width=$(echo "$info." | sed "s/\^[a-z]\+([^)]*)//g")
    indent=$((SCREEN_WIDTH - (${#info_width} * FONT_PIXEL))) 
    echo "^pa(0)$tags^pa($indent)$info"
done | dzen2 -fn "$FONT_FAMILY-$FONT_SIZE" -bg "$BG" -fg "$FG" -dock

