# {{{ ZSH Stuff
# {{{ Autoload ZSH Modules When They Are Referenced

zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof

# }}}
# {{{ Completions

zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.zsh/cache
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' ignore-parents parent pwd
zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for:%b %d'
export EDITOR="/usr/bin/vim" \
	   BROWSER="/usr/bin/iron" \
	   FILEMAN="/usr/bin/thunar2" \
	   PAGER="/usr/bin/most" \
       MANPAGER="/usr/bin/most" \
	   LC="en_US.UTF-8" \
	   LC_ALL="en_US.UTF-8"

# }}}
# {{{ Load ZSH Modules

bindkey -e
autoload -Uz compinit zcalc zsh-mime-setup colors
compinit
autoload -U promptinit
promptinit

# }}}
# {{{ History

HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
setopt EXTENDED_HISTORY		# puts timestamps in the history
setopt HIST_VERIFY			# when using ! cmds, confirm first
setopt HIST_IGNORE_DUPS		# ignore same commands run twice+
setopt APPEND_HISTORY		# don't overwrite history 
setopt SHARE_HISTORY		# _all_ zsh sessions share the same history files
setopt INC_APPEND_HISTORY	# write after each command

# }}}
# {{{ Options

setopt PUSHD_MINUS
setopt NO_HUP
setopt NO_BEEP
setopt NO_CASE_GLOB
setopt IGNORE_EOF
setopt ALL_EXPORT
setopt notify pushdtohome cdablevars autolist
setopt recexact longlistjobs
setopt autoresume histignoredups pushdsilent 
setopt autopushd pushdminus
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt autocd
setopt extendedglob
unsetopt bgnice autoparamslash

# }}}
# }}}
# {{{ Aliases
# {{{ ASCII
alias colorscheme='sh ~/.scripts/Colors/colorscheme'
alias dna='sh ~/.scripts/Colors/dna'
alias invaders='sh ~/.scripts/Colors/invaders'
alias dump-colors='sh ~/.scripts/Colors/dump-colors'
alias pacman-colors='sh ~/.scripts/Colors/pacman-colors'
alias pacman-eats='sh ~/.scripts/Colors/pacman-eats'
alias abc='sh ~/.scripts/Colors/abc'
alias blocks='sh ~/.scripts/Colors/blocks'
alias aliens='sh ~/.scripts/Colors/aliens'
alias batman='sh ~/.scripts/Colors/batman'
alias rally='sh ~/.scripts/Colors/rally'
alias warrior='sh ~/.scripts/Colors/warrior'
alias tubes='sh ~/.scripts/Colors/tubes'
alias eyes='cowsay -f eyes I Am Watching You'
alias futurama='fortune futurama | cowsay -f bender'
alias alsi='sudo alsi -c'
alias matrix='cmatrix -aC yellow'
# }}}
# {{{ CD/DVD Options
alias erase-cd='wodim -v dev=/dev/sr0 -blank=fast'
alias burn-iso='wodim -v dev=/dev/sr0'
alias make-iso='readcd -v dev=/dev/sr0 -f'
alias mount-iso='sudo mount -o loop'
alias make-data='growisofs -Z /dev/sr0 -r -J'
alias iso2dvd='growisofs -dvd-compat -Z /dev/sr0='
alias erase-dvd='dvd+rw-format /dev/sr0'
# }}}
# {{{ Directories
alias apps='/usr/share/applications && ll'
alias themes='/usr/share/themes && ll'
alias icons='/usr/share/icons && ll'
alias pixmaps='/usr/share/pixmaps && ll'
alias downloads='/media/Data/Downloads && ll'
alias music='/media/Data/Music && ll'
alias pictures='/media/Data/Dropbox/Photos && ll'
alias wallpapers='/media/Data/Dropbox/Photos/Wallpapers && ls'
alias videos='/media/Data/Videos && ls'
alias dropdir='/media/Data/Dropbox && ll'
alias documents='/media/Data/Documents && ll'
alias uninettuno='/media/Data/Uninettuno && ll'
alias lessons='/media/Data/Uninettuno/Videolezioni\ Varie && ll'
alias university='/media/Data/Dropbox/Università && ll'
alias archdir='/media/Data/Dropbox/Linux/ArchLinux-Config && ll'
alias books='/media/Data/Dropbox/Libri && ll'
alias colors='~/.scripts/Colors && ls'
alias scripts='~/.scripts && ls'
alias service='cd /usr/lib/systemd/system && ls'
# }}}
# {{{ Dropbox
alias drop='sh ~/.scripts/dropbox'
alias drope='sh ~/.scripts/dropbox | grep errors'
alias restore='sh ~/.scripts/restore'
alias restored='sh ~/.scripts/restore | grep errors'
alias dropdir='/media/Data/Dropbox'
alias d='/usr/bin/dropbox'
alias dropbox='/usr/bin/dropbox'
alias backup='drop && restore'
alias backupe='drope && restored'
# }}}
# {{{ Info
alias bootime='sudo systemd-analyze'
alias bootservice='sudo systemd-analyze blame'
alias bootplot='sudo systemd-analyze plot > plot.svg && viewnior ~/plot.svg && rm ~/plot.svg && clear'
alias plot='bootplot && bootime && bootservice'
alias upmem='ps -eo pmem,pcpu,rss,vsize,args | sort -k 1'
alias pstree="ps auxwwwf"
alias class="xprop | grep --color=none 'WM_CLASS\|^WM_NAME' | xmessage -file -"
alias gputemp='sudo aticonfig --od-gettemperature'
alias temp='sudo hddtemp /dev/sda && sensors | grep Core && sensors | grep temp1'
alias disk='sudo fdisk -l'
alias diskuuid='ll /dev/disk/by-uuid'
alias a='wyrd'
alias dfc='dfc -dw'
alias df='df -hT'
alias free='free -m'
alias frequency='sudo cpupower frequency-info'
alias list-service='ll /etc/systemd/system && ll /etc/systemd/system/multi-user.target.wants'
alias list-all-service='ll /usr/lib/systemd/system'
alias errors='sudo systemctl | grep error'
alias running='sudo systemctl | grep running'
alias stopped='sudo systemctl | grep stopped'
# }}}
# {{{ Managing
alias update='y -Syua'
alias update-initramfs='sudo mkinitcpio -p linux'
alias update-e4rat='sudo e4rat-lite-realloc /var/lib/e4rat-lite/startup.log'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias clean='y -Qdtd --ignore awesome'
alias install='y -S'
alias remove='y -Rsnc'
alias removef='y -Rdd'
alias search='y -Ss' 
alias infos='y -Qi'
alias unlock='rm /var/lib/pacman/db.lck'
alias symlinks='sh ~/.scripts/symlinks'
alias brightness='cat /sys/class/backlight/acpi_video*/brightness'
alias rebuild='cd $HOME/.dwm/ && rm -r pkg src && makepkg -g >> PKGBUILD && makepkg -o && makepkg -efi'
alias cronoff='sudo rm -rv /etc/cron.hourly/disconnect'
alias cronon='sudo cp -Rv ~/.scripts/disconnect /etc/cron.hourly/'
# }}}
# {{{ Mounting
alias mount-all='sh ~/.scripts/mount-all'
alias mount-disk='sh ~/.scripts/mount-disk'
alias mount-usb='sh ~/.scripts/mount-usb'
alias umount-all='sh ~/.scripts/umount-all'
alias umount-disk='sh ~/.scripts/umount-disk'
alias umount-usb='sh ~/.scripts/umount-usb'
# }}}
# {{{ Multimedia
alias setbg='eval $(cat ~/.fehbg)'
alias scrot='sh ~/.scripts/scrot'
alias scrotd='sh ~/.scripts/scrotd'
alias record='sh ~/.scripts/record'
alias recordw='sh ~/.scripts/recordwebcam'
alias recordv='ffmpeg -f alsa -i default -f v4l2 -s 640x480 -i /dev/video0 out.mkv'
alias recordvideo='ffmpeg -f alsa -i default -f v4l2 -s 640x480 -i /dev/video0 video.mpg'
alias qiv='qiv -u -W 85 -tipTB'
alias webcam='mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -title Webcam -fps 25 -vf screenshot '
alias motioncam='mplayer http://localhost:8081'
alias resizeimage='sh ~/.scripts/resizeimage'
alias convertmedia='sudo sh ~/.scripts/convertmedia'
alias play='mplayer -dvd-device /dev/sr0 dvd://1'
alias volume='alsamixer'
alias subeng='submarine -l eng'
alias subita='submarine -l ita'
alias subrename='sh ~/.scripts/subrename'
alias m='ncmpcpp'
alias mpcs='mpc status -f "Title: %title%    Artist: %artist%    Album: %album% "'
alias append-pdf='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=output.pdf'
# }}}
# {{{ Package Managers
alias p='sudo pacman-color'
alias y='yaourt'
alias u='update'
# }}}
# {{{ Pipes
alias -g G='| grep'
alias -g S='| sort'
alias -g L='| less'
alias -g T='| tail'
alias -g H='| head'
alias -g DN='/dev/null'
alias -g NULL='> /dev/null 2>&1'
# }}}
# {{{ System
alias c='clear'
alias ll='ls -lA'
alias ls='ls --color=auto -A'
alias reload='clear && source ~/.zshrc'
alias rm='sudo rm -rv'
alias rem='sudo rm -vi'
alias copy='cp -f'
alias cp='cp -Rv'
alias mv='mv -vi'
alias reboot='sudo sh ~/.scripts/reboot'
alias poweroff='sudo sh ~/.scripts/poweroff'
alias powerdown='sudo sh ~/.scripts/powerdown'
alias powerup='sudo sh ~/.scripts/powerup'
alias hibernate='sudo systemctl hibernate'
alias suspend='sudo systemctl suspend'
alias open='xdg-open'
alias ':q'='exit'
alias god='sudo -s'
alias defrag='sudo shake -pv'
alias smallfont='sh ~/.scripts/setsmallfont'
alias bigfont='sh ~/.scripts/setbigfont'
# }}}
# {{{ Tmux

[ "$TERM" = screen ] && export TERM=screen-256color

#if [[ -z "$TMUX" ]]; then
#        tmux 
#fi

alias t='tmux'
alias ta='tmux a'
alias at='tmux a -t'

# }}}
# {{{ Web
alias wifi='sudo wifi-select wlan0'
alias mac-address='ifconfig | grep HWaddr'
alias my-ip='sh ~/.scripts/ip'
alias youtube='youtube-viewer -m -C'
alias chat='[ $(pidof weechat-curses) ] && tmux attach -t Chat || tmux new -s Chat weechat-curses'
alias mail='mutt'
alias feed='newsbeuter'
alias share='my-ip && quickserve -p 4662'
alias logprivoxy='sudo tail -f /var/log/privoxy/logfile'
alias logtor='sudo tail -f /var/log/messages.log | grep "localhost Tor"'
alias starttor='sudo sh ~/.scripts/starttor'
alias stoptor='sudo sh ~/.scripts/stoptor'
alias connect='sh ~/.scripts/connect'
alias disconnect='sh ~/.scripts/disconnect'
alias reconnect='sh ~/.scripts/disconnect && sh ~/.scripts/connect'
alias dns='cat /etc/resolv.conf'
alias setdns='sudo sh ~/.scripts/setdns'
alias setdnstor='sudo sh ~/.scripts/setdnstor'
alias setdnsgoogle='sudo sh ~/.scripts/setdnsgoogle'
alias restartwifi='sudo sh ~/.scripts/restartwifi'
alias list-flash='sh ~/.scripts/list-flash'
alias github='sh ~/.scripts/github'
alias w3mc='w3m -cookie'
alias torrent='[ $(pidof rtorrent) ] && tmux attach -t Torrent || tmux new -s Torrent rtorrent'
alias radio='tmux new -s radio radio'
alias pandora='[ $(pidof pianobar) ] && tmux attach -t Pandora || tmux new -s Pandora pianobar'
alias twitter='ttytter -ansi'
alias download='plowdown -o /media/Data/Downloads'
alias ie='google-translate ita eng'
alias ei='google-translate eng ita'
alias it='google-translate ita de'
alias ti='google-translate de ita'
alias translate='google-translate'
alias wlan0='slurm -i wlan0'
alias eth0='slurm -i eth0'
alias wificrack='cd /opt/wepcrackgui && ./wepcrack'
alias google-earth='google-earth6 -fn -xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso8859-9'
# }}}
# }}}
# {{{ Custom Prompt

local curdir="%d"
local hostname="%M"
local username="%n"
local bold="%B"
local unbold="%b"
local standout="%S"
local unstandout="%s"
local colorfg="%F"
local uncolorfg="%f"
local colorbg="%K"
local uncolorbg="%k"
local mytime="%*"
local mydate="%D"
local line_tty="%y"
local rootorwhat="%#"
local return_status="%?"

if [ -n "$SSH_CLIENT" ]; then
PROMPT="%F{red}SSH%f %F{red} >%f "
else
PROMPT="%F{red} >%f "
fi

# {{{ Other Prompts

#export ps1=$'%F{black}%B┌%K{black}%F{blue}%B %n %b%f%k%K{black}·%F{red} %T %f%k%K{black}·%F{green} %y %f%k%K{black}·%F{yellow}%B %~ %b%f%k
#%F{black}%B└%{\e[40;1;37m%} %% %{\e[0m%}%F{black}%B¬%b%f '
#export PS2=$'%{\e[1;33m%} %_>%{\e[0m%} '

#export PS1=$'%B┌%b[%B%n%b~%d]
#%B└%b[%#]%B¬%b '
#export PS2=$'%{\e[1;33m%} %_>%{\e[0m%} '

#PROMPT=" %F{yellow}%B%n%b%f %F{red}|%f %F{blue}%*%f %F{red}|%f %F{green}${PWD/#$HOME/~}%f 
# %F{red}%(!.● .● )%f% %F{blue}%(!.● .● )%f% %F{green}%(!.● .● )%f%"
#RPROMPT="%F{yellow}%*%f"

#PROMPT=" %F{yellow}%d%f %F{red}%(!.> .> )%f%"

#if [ -n "$SSH_CLIENT" ]; then
#PROMPT="%F{green}┌─╼%f %F{red}SSH%f %F{cyan}%M%f%F{magenta}%n%f %F{green}~%f %F{green}%B%d%b%f
#%F{green}└────╼%f  "
#RPROMPT="%F{cyan}%*%f"
#else
#PROMPT="%F{green}┌─╼%f %F{cyan}%M%f%F{magenta}%n%f %F{green}~%f %F{green}%B%d%b%f
#%F{green}└────╼%f  "
#RPROMPT="%F{cyan}%*%f"
#fi

#PROMPT="$colorfg{blue}$uncolorfg$bold$curdir$unbold$colorfg{blue}$uncolorfg
#$username$bold$colorfg{red}:${uncolorfg}$unbold$hostname $colorfg{yellow}»$uncolorfg "

# }}}

# }}}
# {{{ Color Support

eval "`dircolors -b $HOME/.LS_COLORS`"
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
export LS_COLORS
export PATH=/usr/share/perl5/vendor_perl/auto/share/dist/Cope:$PATH
# export PATH="/usr/lib/cw:$PATH"

# }}}
# {{{ Functions
# {{{ Archives
# {{{ Creates An Archive From Given Directory

mktar() { tar cvf       "${1%%/}.tar"       "${1%%/}/"; }
mktgz() { tar cvzf      "${1%%/}.tar.gz"    "${1%%/}/"; }
mktbz() { tar cvjf      "${1%%/}.tar.bz2"   "${1%%/}/"; }
mkrar() { rar a -m5 -r  "${1%%/}.rar"       "${1%%/}/"; }
mkzip() { zip -9r       "${1%%/}.zip"       "${1%%/}/"; }
mk7z()  { 7z a -mx9     "${1%%/}.7z"        "${1%%/}/"; }
 
# }}}
# {{{ Extract Archives

alias extract='atool -x'

#extract () {
#     if [ -f $1 ] ; then
#         case $1 in
#             *.tar.bz2)   tar xjf $1    ;;
#             *.tar.gz)    tar xzf $1    ;;
#             *.bz2)       bunzip2 $1    ;;
#             *.rar)       unrar x $1    ;;
#             *.gz)        gunzip $1     ;;
#             *.tar)       tar xf $1     ;;
#             *.tbz2)      tar xjf $1    ;;
#             *.tgz)       tar xzf $1    ;;
#             *.zip)       unzip $1      ;;
#             *.Z)         uncompress $1 ;;
#             *.7z)        7z x $1       ;;
#             *)           echo "'$1' cannot be extracted via extract()" ;;
#         esac
#     else
#         echo "'$1' is not a valid file"
#     fi
#}

# }}}
# }}}
# {{{ Cat, Sed, Awk, Grep, Less Syntax Highlighting

cat sed awk grep() {
  syntax=""
  type highlight > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    for file in $@; do
      if [ -f $file ]; then
        case $file in
          *.java) syntax="java";;
          *.php) syntax="php";;
          *.py) syntax="python";;
          *.diff) syntax="diff";;
          *.awk) syntax="awk";;
          *.c) syntax="c";;
          *.css) syntax="css";;
          *.js) syntax="js";;
          *.jsp) syntax="jsp";;
          *.xml) syntax="xml";;
          *.sql) syntax="sql";;
          *.pl) syntax="pl";;
          *.rb) syntax="rb";;
          /etc/apache*/*) syntax="httpd";;
        esac
      fi
    done
  fi
  if [[ $syntax != "" ]]; then
    command $0 $@ | highlight -O ansi --syntax=$syntax
  else
    command $0 $@
  fi
}

lessr() { cat $1 | less -R }

# }}}
# {{{ Check If A Package Is Installed

installed () {
    case $1 in  
        *)          if [ -f "$1" ]; then
						if [ -w "$1" ]; then		
							"$1"
						fi
					else 
						yaourt -Ss "$1" | grep installed 
					fi ;;
   esac
}

# }}}
# {{{ Cleanup

cleanup () {
    echo -e "==> Cleaning Thumbnails"
    sudo /bin/rm -rfv ~/.thumbnails/*
    sudo /bin/rm -rfv /root/.thumbnails/*
    echo "==> Removing Flash Player Cache"
    sudo /bin/rm -rfv ~/.adobe/*
    sudo /bin/rm -rfv /root/.adobe/*
    sudo /bin/rm -rfv ~/.macromedia/*
    sudo /bin/rm -rfv /root/.macromedia/*
    echo "==> Cleaning Cache"
    sudo polipo -x
    sudo /bin/rm -rfv /var/cache/polipo/*
    sudo /bin/rm -rfv ~/.cache/*
    sudo /bin/rm -rfv /root/.cache/*
    sudo /bin/rm -rfv ~/.dvdcss/*
    echo "==> Cleaning Trash"
    sudo /bin/rm -rfv ~/.local/share/Trash/*
    sudo /bin/rm -rfv /root/.local/share/Trash/*
    sudo /bin/rm -rfv /tmp/*part
    sudo /bin/rm -rfv /home/.Trash-0/*
    sudo /bin/rm -rfv /media/Winzoz/*.Bin/*
    sudo /bin/rm -rfv /media/Winzoz/System*/*
    sudo /bin/rm -rfv /media/Data/*.Bin/*
    sudo /bin/rm -rfv /media/Data/System*/*
    sudo /bin/rm -rfv /media/Riserva/*.Bin/*
    sudo /bin/rm -rfv /media/Riserva/System*/*
    echo
}

# }}}
# {{{ Config

config () {
    case $1 in  
        autostart)  $EDITOR ~/.scripts/autostart ;;
        awesome)    $EDITOR ~/.config/awesome/rc.lua ;;
        awesomebig) $EDITOR ~/.config/awesome/rc_BIG.lua ;;
        awesomesmall) $EDITOR ~/.config/awesome/rc_SMALL.lua ;;
        boot)       sudo $EDITOR /boot/grub/grub.cfg ;;
        chat)       $EDITOR ~/.weechat/weechat.conf ;;
        colors)     $EDITOR ~/.colors/Terminal/colored ;;
        conky)      $EDITOR ~/.conkyrc ;;
        dns)        sudo $EDITOR /etc/pdnsd.conf ;;
        dns-tor)    sudo $EDITOR /etc/pdnsd-tor.conf ;;
        dropbox)    $EDITOR ~/.scripts/dropbox ;;
        dwm)        $EDITOR ~/.dwm/config.h ;;
        elinks)     $EDITOR ~/.elinks/elinks.conf ;;
        feed)       $EDITOR ~/.newsbeuter/config ;;
        feed-url)   $EDITOR ~/.newsbeuter/urls ;;
        fstab)      sudo $EDITOR /etc/fstab ;;
        grub)       sudo $EDITOR /etc/default/grub ;;
        hosts)      sudo $EDITOR /etc/hosts ;;
        init)       sudo $EDITOR /etc/mkinitcpio.conf ;;
        irc)        $EDITOR ~/.weechat/irc.conf ;;
        ls)         $EDITOR ~/.LS_COLORS ;;
        mail)       $EDITOR ~/.muttrc ;;
        most)       sudo $EDITOR /etc/most.conf ;;
        motion)     sudo $EDITOR ~/.motion/motion.conf ;;
        mpd)        sudo $EDITOR /etc/mpd.conf ;;
        mplayer)    sudo $EDITOR ~/.mplayer/config ;;
        music)      $EDITOR ~/.ncmpcpp/config ;;
        open)       $EDITOR ~/.local/share/applications/mimeapps.list ;;
		pacman)		sudo $EDITOR /etc/pacman.conf ;;
        pianobar)   sudo $EDITOR ~/.config/pianobar/config ;;
        polipo)     sudo $EDITOR /etc/polipo/config ;;
        powerdown)  sudo $EDITOR ~/.scripts/powerdown ;;
        powerup)    sudo $EDITOR ~/.scripts/powerup ;;
        psd)        sudo $EDITOR /etc/psd.conf ;;
		radeon)		sudo $EDITOR /etc/X11/xorg.conf.d/20-radeon.conf ;;
        restore)    $EDITOR ~/.scripts/restore ;;
        slim)       sudo $EDITOR /etc/slim.conf ;;
        ssh)        sudo $EDITOR /etc/ssh/ssh_config ;;
        sshd)       sudo $EDITOR /etc/ssh/sshd_config ;;
        symlinks)   $EDITOR ~/.scripts/symlinks ;;
        terminal)   $EDITOR ~/.Xdefaults ;;
        terminalbig) $EDITOR ~/.Xdefaults_BIG ;;
        terminalsmall) $EDITOR ~/.Xdefaults_SMALL ;;
        theme)      $EDITOR ~/.config/awesome/themes/colored/theme.lua ;;
        themebig)   $EDITOR ~/.config/awesome/themes/colored/theme_BIG.lua ;;
        themesmall) $EDITOR ~/.config/awesome/themes/colored/theme_SMALL.lua ;;
        tmux)       $EDITOR ~/.tmux.conf ;;
        tor)        sudo $EDITOR /etc/tor/torrc ;;
        torrent)    $EDITOR ~/.rtorrent.rc ;;
        vim)        $EDITOR ~/.vimrc ;;
        vim-color)  $EDITOR /usr/share/vim/vim73/colors/colored.vim ;;
        vimperator) $EDITOR ~/.vimperator/colors/awesome.vimp ;;
        wyrd)       $EDITOR ~/.wyrdrc ;;
        xinit)      $EDITOR ~/.xinitrc ;;
		xorg)		sudo $EDITOR /etc/X11/xorg.conf ;;
        zathura)    $EDITOR ~/.config/zathura/zathurarc ;;
        zsh)        $EDITOR ~/.zshrc ;;
        # Invalid
        *)          if [ -f "$1" ]; then
						if [ -w "$1" ]; then		
							$EDITOR "$1"
						else
							sudo $EDITOR "$1"
						fi
					else 
						echo "Invalid Option" 
					fi ;;
   esac
}

# }}}
# {{{ Create ISO From Device Or Directory

mkiso()
{
  case $1 in
    /dev/*)
      dd if=$1 of=$2 ;;
    *)
      mkisofs -o $2 $1 ;;
  esac
}

# }}}
# {{{ Cron

cron () {
    echo  "==> Logrotate"
    sudo sh /etc/cron.daily/logrotate
    echo  "==> Man DB"
    sudo sh /etc/cron.daily/man-db
    echo  "==> UpdateDB"
    sudo sh /etc/cron.daily/updatedb
    echo  "==> 0Anacron"
    sudo sh /etc/cron.hourly/0anacron
    echo  "==> Get Ip"
    getip
    echo
}

# }}}
# {{{ FFMPEG Stuffs
# {{{ Split Video

ffmpeg_splitvid()
{
  local t=$(epoch `ffprobe $1 2>&1 | grep Duration | cut -b 13-20`)
  local first=$(( $t / 3 ))
  local second=$(( $first * 2 ))
  local duration=$(( $first + 30 ))

  ffmpeg -i $1 -ss 0 -t $duration -vcodec copy -sameq -acodec copy -async 100 -threads 0 ${1%.*}.part1.avi
  ffmpeg -i $1 -ss $first -t $duration -vcodec copy -sameq -acodec copy -async 100 -threads 0 ${1%.*}.part2.avi
  ffmpeg -i $1 -ss $second -t $duration -vcodec copy -sameq -acodec copy -async 100 -threads 0 ${1%.*}.part3.avi
}

ffmpeg_bframes()
{
  ffmpeg -i $1 -vcodec copy -sameq -acodec libmp3lame -ab 128k -ar 48000 -ac 2 -threads 0 ${1%.*}.fix.avi
}

# }}}
# {{{ Convert To x264

ffmpeg_x264() {
  ffmpeg -i $1 -acodec aac -strict experimental -ab 96k -vcodec libx264 -vpre slow -crf 22 -threads 0 -f matroska ${1%.*}.mkv
} 

# }}}
# {{{ Rip Audio As MP3

ffmpeg_mp3() {
  ffmpeg -i $1 -acodec libmp3lame -sameq -threads 0 ${1%.*}.mp3
}

# }}}
# {{{ Convert Anything To iPhone And Move To LAMP For Streaming

ffmpeg_iphone()
{
    ffmpeg -i $1 -acodec libfaac -ab 128k -vcodec libx264 -vpre ipod640 -s 480x320 -r 29 -threads 0 ${1%.*}.mp4
    mv ${1%.*}.mp4 ~/www/iphone/
}

# }}}
# }}}
# {{{ Oneliners

goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }
cpf() { cp "$@" && goto "$_"; }
sw() { sudo cp "$@" /usr/share/slim/themes/Highway/background.png }
mvf() { mv "$@" && goto "$_"; }
mkf() { mkdir -p $1; cd $1 }
cdl() { cd $@; ll }
da() { ($1 &) }
zsh-stats() { history | awk '{print $2}' | sort | uniq -c | sort -rn | head }
dirsize() { du -h --max-depth=1 "$@" | sort -k 1,1hr -k 2,2f; }

# }}}
# {{{ Optimize

optimize () {
    echo  "==> Optimizing Pacman"
    y -Scc --noconfirm
    sudo pacman-db-upgrade
    sudo pacman-optimize
    sync
    sudo updatedb
    echo  "==> Optimizing Firefox"
    sh ~/.scripts/datafox
    echo  "==> Optimizing Chromium"
    sh ~/.scripts/datachrome
    echo
}

# }}}
# {{{ Presentation

color-block () {	
	echo
	width=$(( (`tput cols` / 16) -1 ))
	chars=""
	prespaces=$(( (`tput cols`-($width+1)*16)/2 ))
	for i in `seq $width`; chars="${chars}|"
	for i in `seq $prespaces`; echo -n " "
	for i in `seq 0 7`; echo -en "\e[3${i}m${chars} \e[1;3${i}m${chars}\e[m "; echo; echo
	unset width
	unset chars
	unset prespaces
}

color-blocks () {   
    echo
    local width=$(( ($COLUMNS / 16) -1 ))
    local chars
    local pre=$(( ( $COLUMNS - ($width+1)*16)/2 ))
    for ((i=0; i<$width; i++)); chars+="\u2591"
    for ((i=0; i<$pre; i++)); echo -n " " 
    for ((i=0; i<=7; i++)); echo -en "\e[3${i}m${chars} \e[1;3${i}m${chars}\e[m "; echo; echo
    unset i
}

# }}}
# {{{ Rip Audio CDs to MP3

ripdatshit()
{
  echo "MP3 VBR quality setting: [0-9]"
  read $q
  mkdir $HOME/tmp/rip
  cd $HOME/tmp/rip
  cdparanoia -B
  for i in *.wav; do
    lame -V $q $i mp3/${i%.*.*}.mp3
  done
  echo "Tag mp3 files with Easytag? [y/n]"
  read $yn
  if [[ "$yn" == "y" ]]; then
    easytag $HOME/tmp/rip
  fi
}

# }}}
# {{{ Systemd

if ! systemd-notify --booted; then # not using systemd
  start() {
    sudo rc.d start $1
  }

  restart() {
    sudo rc.d restart $1
  }

  stop() {
    sudo rc.d stop $1
  }
else
  start() {
    sudo systemctl start $1
  }

  restart() {
    sudo systemctl restart $1
  }

  stop() {
    sudo systemctl stop $1
  }

  enable() {
    sudo systemctl enable $1
  }

  status() {
    sudo systemctl status $1
  }

  disable() {
    sudo systemctl disable $1
  }
fi

# }}}
# {{{ Update Clock

update-clock () {
	sudo ntpdate -s time.ien.it
	sudo hwclock -w
}

# }}}
# {{{ Vim Font

#vim_font() {
#    echo -e '\e]710;xft:Termsyn:pixelsize=17:antialias=true:hinting=true\007'          # New Font
#    vim $*
#    echo -e '\e]710;xft:tamsyn:pixelsize=15:antialias=true:hinting=true\007'         # Old Font
#}
#alias vim='vim_font'

# }}}
# }}}
# {{{ Startup Functions

# fortune | cowsay -f tux
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-syntax-highlighting/06-syntax-rules.zsh
#color-blocks
#color-block

# }}}
