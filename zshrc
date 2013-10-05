## {{{ General zsh settings

# prompt
autoload -U compinit promptinit
compinit
promptinit

# menu driven auto complete
#zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' completer _expand _complete _approximate _ignored _match
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select=2
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*:jobs' verbose yes
zstyle ':vcs_info:*' branchformat "%b"
zstyle ':vcs_info:*' actionformats "(%s/%b/%a)"
zstyle ':vcs_info:*' formats "(%s/%b)"
zstyle ':vcs_info:git:*' actionformats " %(%b/%a)"
zstyle ':vcs_info:git:*' formats "(%b)"
setopt completealiases

# Colors
export NC='\e[0m'
export white='\e[0;30m'
export WHITE='\e[1;30m'
export red='\e[0;31m'
export RED='\e[1;31m'
export green='\e[0;32m'
export GREEN='\e[1;32m'
export yellow='\e[0;33m'
export YELLOW='\e[1;33m'
export blue='\e[0;34m'
export BLUE='\e[1;34m'
export magenta='\e[0;35m'
export MAGENTA='\e[1;35m'
export cyan='\e[0;36m'
export CYAN='\e[1;36m'
export black='\e[0;37m'
export BLACK='\e[1;37m'


# command not found using pkgfile
source /usr/share/doc/pkgfile/command-not-found.zsh

# prompt syntax highlight
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# disable auto-complete
unsetopt correct_all

setopt AUTO_CD

# Allow comments even in interactive shells (especially for Muness)
setopt INTERACTIVE_COMMENTS

# ===== History
# Allow multiple terminal sessions to all append to one zsh command history
setopt APPEND_HISTORY 

# Add comamnds as they are typed, don't wait until shell exit
setopt INC_APPEND_HISTORY 

# Do not write events to history that are duplicates of previous events
setopt HIST_IGNORE_DUPS

# When searching history don't display results already cycled through twice
setopt HIST_FIND_NO_DUPS

# Remove extra blanks from each command line being added to history
setopt HIST_REDUCE_BLANKS

# Include more information about when the command was executed, etc
setopt EXTENDED_HISTORY

# ===== Completion 
# Allow completion from within a word/phrase
setopt COMPLETE_IN_WORD 

# When completing from the middle of a word, move the cursor to the end of the word
setopt ALWAYS_TO_END            

# {{{ setup special keys
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
# }}}
# Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt PROMPT_SUBST
unsetopt AUTO_NAME_DIRS

unsetopt MENU_COMPLETE
setopt AUTO_MENU
## }}} general zsh options
# {{{ General Aliases
alias zshconfig='vim ~/.zshrc'
alias tmux='tmux -2'
alias monitor-off='sleep 1; xset dpms force off'
#alias grep='grep  --color=auto'
#alias egrep='egrep --color-auto'
#alias fgrep='fgrep --color-auto'
alias ping='ping -c 5'
alias diff='colordiff'
alias more='less'
alias df='df -h'
alias du='du -h'
alias du-sum='du -c -h'
alias mkdir='mkdir -p -v'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias bk='cd $OLDPWD'
alias dus='du -sckxh * | sort -nr' #directories sorted by size
alias pacman='sudo pacman'
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias sz='source ~/.zshrc'
alias ls='ls -hF --color=auto'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'
alias l='ls++'
alias lh='ls | bidiv'
alias fu='fu -n5'
alias vboxmanage='VBoxManage'
alias vboxheadless='VBoxHeadless'
alias vbox='vbox-modules-load && VirtualBox'
alias vimconfig='vim ~/.vimrc'
alias code='vim ~/work/code'
alias torrent='cd ~/Downloads/torrents'
alias tv='cd ~/tv && ranger'
alias books='cd ~/books && ranger'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias tmconfig='vim ~/.tmux.conf'
alias l.='ls -d .* --color=auto'
alias mount-show='mount | column -T'
alias ports='sudo netstat -tulanp | grep -i listen'
alias s='sr -browser=google-chrome google'
alias chrome='google-chrome'
alias awconfig='vim ~/.config/awesome/rc.lua && awesome -k ~/.config/awesome/rc.lua'
alias awtheme='cd ~/.config/awesome/themes'
alias open='xdg-open'
alias startx='startx &> ~/.xlog'
alias tl='tmux ls'
alias ta='tmux attach -t'
alias ts='tmux new -s'
alias q='exit'
alias mount-iso='sudo mount -o loop'
alias systemctl='sudo systemctl'
alias scrot='cd ~/shots && scrot'
alias goodnight='sleep 60; monitor-off'
alias seedbox='ssh nir@10.0.0.255'

alias cfg='cd ~/.config'
alias dmesg-f='dmesg -L -H -w'
# }}}
# {{{  Pacman aliases
alias pac="sudo pacman -S"      # default action        - install one or more packages
alias pacu="sudo pacman -Syu"   # '[u]pdate'            - upgrade all packages to their newest version
alias pacs="sudo pacman -Ss"    # '[s]earch'            - search for a package using one or more keywords
alias paci="sudo pacman -Si"    # '[i]nfo'              - show information about a package
alias pacr="sudo pacman -R"     # '[r]emove'            - uninstall one or more packages
alias pacp="sudo pacman -Rns"   # '[p]urge'             - purge a package + config files
alias pacl="sudo pacman -Sl"    # '[l]ist'              - list all packages of a repository
alias pacll="sudo pacman -Qqm"  # '[l]ist [l]ocal'      - list all packages which were locally installed (e.g. AUR packages)
alias paclo="sudo pacman -Qdt"  # '[l]ist [o]rphans'    - list all packages which are orphaned
alias paco="sudo pacman -Qo"    # '[o]wner'             - determine which package owns a given file
alias pacf="sudo pacman -Ql"    # '[f]iles'             - list all files installed by a given package
alias pacc="sudo pacman -Sc"    # '[c]lean cache'       - delete all not currently installed package files
alias pacm="makepkg -fci"       # '[m]ake'              - make package from PKGBUILD file in current directory
alias pacin="sudo pacman -U"    #  [in]stall            -install local package ##aur
# }}} pacman aliases
# {{{ Custom functions
# {{{ systemd functions
 start() { sudo systemctl start $1.service ; sudo systemctl status $1.service;
 }

 restart() {   sudo systemctl restart $1.service ; sudo systemctl status
 $1.service; }

 stop() { sudo systemctl stop $1.service ; sudo systemctl status $1.service; }

 enable() { sudo systemctl enable $1.service ; ls -l
         /etc/systemd/system/multi-user.target.wants; }

 disable() { sudo systemctl disable $1.service ; ls -l
 /etc/systemd/system/multi-user.target.wants; }

 listd() { ls -l /etc/systemd/system/multi-user.target.wants; }
 
 status() { sudo systemctl status $1.service; }
# }}} systemd functions
# {{{ less colors for man pages
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}
# }}} less colors
# {{{ locate discover
discover () {
        keyword=$(echo "$@" |  sed 's/ /.*/g' | sed 's:|:\\|:g' | sed 's:(:\\(:g' | sed 's:):\\):g') 
        locate -ir $keyword
}
# }}} locate discover
# {{{ hebrew discover
discover-h () {
        keyword=$(echo "$@" |  sed 's/ /.*/g' | sed 's:|:\\|:g' | sed 's:(:\\(:g' | sed 's:):\\):g') 
        locate -ir $keyword | bidiv
}
# }}} hebrew discover
## {{{  w3m image support
w3mimg () { w3m -o imgdisplay=/usr/lib/w3m/w3mimgdisplay $1
}
# }}}
# {{{ google translate with RTL support
t () { translate $@ | bidiv
}
# }}} google translate
# }}} custom functions
# {{{ Environment variables
export EDITOR="vim"
export BROWSER="chromium"
export PDF="zathura"
export VIDEO="mpv"
export PATH=/opt/java/bin:~/scripts:"$PATH"
export GDK_USE_XFT=1
export LESSOPEN='| /usr/bin/source-highlight-esc.sh %s'
export LESS=' -R '
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'

eval $(dircolors -b)
source liquidprompt
# }}} Variables
