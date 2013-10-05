#!/bin/env bash

function statusbar {

	function desk() {
	DESKTOP=$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')
	case $DESKTOP in
		0)	echo "Web"
			;;
		1)	echo "Term"
			;;
		2)	echo "FM"
			;;
		3)	echo "Docs"
			;;
		4)	echo "Media"
			;;
		*)	echo "error"
	esac
	}

	function clock() {
	time=$(date "+%e.%m %R")
	echo $time
	}

    function temp() {
    tem=$(sensors | grep "Physical id 0" | awk '{print $4}' | cut -b 2-)
    echo $tem
    }


    function mem() {
    free=$(free -m | grep buffers | awk '{print $3}' | awk '/[0-9]/')
    echo $free
    }

	function sda() {
	dfh=$(dfc | grep "/dev/sda2" | awk '{print $3}')
	echo $dfh
	}

	function vol() {
	ami="$(amixer get Master | awk '/Front Left:/ {print $5}' | tr -d "[]")"
	echo $ami
	}
	
	
	echo "^fg(#8A2F58):bspwm = _"$(desk)"_ ^fg(#AAAAAA) (^fg(#287373) :gen^fg(#AAAAAA) ((^fg(#914E89):mem $(mem)M^fg(#98CBFE) :sda $(sda)   (^fg(#5E468C)temp: $(tem)°C^fg(#AAAAAA) ))^fg(#E5B0FF) (^fg(#395573) :sy^fg(#AAAAAA)(^fg(#CF4F88)^fg(AAAAAA) )^fg(#47959E)[setf *alsa*] :vol $(vol)^fg(#AAAAAA) ))(^fg(#FFFFFF)cons '$(clock)')^fg(#AAAAAA))"
}
 while true 
 do
	 echo "$(statusbar)"
	sleep 0.5	
 done | dzen2 -bg '#000000' -fn '-*-terminus-medium-r-*-*-13-*-*-*-*-*-*-*' -tw 1920 -x 0 -ta r -p &

