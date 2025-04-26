#!/usr/bin/env bash
# impovised from GitHub; ChrisTitus's mybash
case $- in
*i*) ;;
*) return ;;
esac

# Returns the last 2 fields of the working directory
distribution() {
    local dtype="unknown" # Default to unknown

    # Use /etc/os-release for modern distro identification
    if [ -r /etc/os-release ]; then
        source /etc/os-release
        case $ID in
        fedora | rhel | centos)
            dtype="redhat"
            ;;
        sles | opensuse*)
            dtype="suse"
            ;;
        ubuntu | debian)
            dtype="debian"
            ;;
        gentoo)
            dtype="gentoo"
            ;;
        arch | manjaro)
            dtype="arch"
            ;;
        slackware)
            dtype="slackware"
            ;;
        *)
            # Check ID_LIKE only if dtype is still unknown
            if [ -n "$ID_LIKE" ]; then
                case $ID_LIKE in
                *fedora* | *rhel* | *centos*)
                    dtype="redhat"
                    ;;
                *sles* | *opensuse*)
                    dtype="suse"
                    ;;
                *ubuntu* | *debian*)
                    dtype="debian"
                    ;;
                *gentoo*)
                    dtype="gentoo"
                    ;;
                *arch*)
                    dtype="arch"
                    ;;
                *slackware*)
                    dtype="slackware"
                    ;;
                esac
            fi

            # If ID or ID_LIKE is not recognized, keep dtype as unknown
            ;;
        esac
    fi

    echo $dtype
}
# setting a distro variable for potential future use
DISTRIBUTION=$(distribution)
# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip() {
    # Internal IP Lookup.
    if command -v ip &>/dev/null; then
        echo -n "Internal IP: "
        ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        echo -n "Internal IP: "
        ifconfig wlan0 | grep "inet " | awk '{print $2}'
    fi

    # External IP Lookup
    echo -n "External IP: "
    curl -s ifconfig.me
}

iatest=$(expr index "$-" i)
# if [ -f /usr/bin/fastfetch ]; then
# 	fastfetch
# fi
# Running colorscript and fastfetch only if not in a tmux session
# and if bashrc has not been sourced before
if [ -z "$BASHRC_SOURCED" ]; then
    export BASHRC_SOURCED=1
    # Run your command here
    if [[ -z "$TMUX" ]]; then
        # Run fastfetch only if not in a tmux session
        if command -v fastfetch &>/dev/null; then
            fastfetch
        fi
        if command -v colorscript &>/dev/null; then
            colorscript random
        fi

    fi
fi
# Show the current version of the operating system
ver() {
    local dtype
    dtype=$(distribution)

    case $dtype in
    "redhat")
        if [ -s /etc/redhat-release ]; then
            cat /etc/redhat-release
        else
            cat /etc/issue
        fi
        uname -a
        ;;
    "suse")
        cat /etc/SuSE-release
        ;;
    "debian")
        lsb_release -a
        ;;
    "gentoo")
        cat /etc/gentoo-release
        ;;
    "arch")
        cat /etc/os-release
        ;;
    "slackware")
        cat /etc/slackware-version
        ;;
    *)
        if [ -s /etc/issue ]; then
            cat /etc/issue
        else
            echo "Error: Unknown distribution"
            exit 1
        fi
        ;;
    esac
}

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
# Disable the bell
if [[ $iatest -gt 0 ]]; then bind "set bell-style visible"; fi
# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T" # add timestamp to history
# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'
# set up XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
# Allow ctrl-S for history navigation (with ctrl-R)
[[ $- == *i* ]] && stty -ixon
# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi
# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
#export GREP_OPTIONS='--color=auto' #deprecated

# Check if ripgrep is installed
if command -v rg &>/dev/null; then
    # Alias grep to rg if ripgrep is installed
    alias grep='rg'
else
    # Alias grep to /usr/bin/grep with GREP_OPTIONS if ripgrep is not installed
    alias grep="/usr/bin/grep $GREP_OPTIONS"
fi
unset GREP_OPTIONS
# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rmd='\rm  --recursive --force --verbose '
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias cls='clear'
alias apt-get='sudo apt-get'
if command -v freshclam >/dev/null 2>&1; then
    alias freshclam='sudo freshclam'
fi
if command -v multitail >/dev/null 2>&1; then
    alias multitail='multitail --no-repeat -c'
fi
if command -v lazygit >/dev/null 2>&1; then
    alias lg='lazygit'
fi
if command -v nvim >/dev/null 2>&1; then
    # Edit this .bashrc file
    alias ebrc='nvim ~/.bashrc'
    # echo "Program 'nvim' exists"
    alias vi='nvim'
    alias svi='sudo vi'
    alias vis='nvim "+set si"'
    if [ -d ~/.config/nvchadnvim ]; then
        alias nvvi="NVIM_APPNAME=nvchadnvim nvim"
    fi
    if [ -d ~/.config/lazynvim ]; then
        alias lavi="NVIM_APPNAME=lazynvim nvim"
    fi
    if [ -d ~/.config/astronvim ]; then
        alias asvi="NVIM_APPNAME=astronvim nvim"
    fi
    if [ -d ~/.config/freshnvim ]; then
        alias frvi="NVIM_APPNAME=freshnvim nvim"
        alias v="NVIM_APPNAME=freshnvim nvim"
    fi
    # alias asvi="NVIM_APPNAME=astronvim nvim"
    if [ -f ~/.local/bin/lvim ]; then
        alias luvi="~/.local/bin/lvim"
    fi
    # if [ -d ~/.config/vimacsnvim ]; then
    #     alias vivi="NVIM_APPNAME=vimacsnvim nvim"
    # fi
    # Set the default editor
    alias freshnvim='NVIM_APPNAME=freshnvim nvim'
    export EDITOR=freshnvim
    # export EDITOR=v
    export VISUAL=freshnvim
fi
alias less='less -R'

if [ -f ~/.blerc.sh ]; then
    alias b_c="source ~/.blerc.sh"
fi
if command -v x86_64-w64-mingw32-gcc >/dev/null 2>&1; then
    alias wingcc="x86_64-w64-mingw32-gcc"
fi
if command -v xel >/dev/null 2>&1; then
    # echo "Program 'xsel' exists"
    alias xcopy="xsel --input --clipboard"
    alias xpaste="xsel --output --clipboard"
fi
if command -v nala >/dev/null 2>&1; then
    # echo "Program 'nala' exists"
    alias apt="sudo nala"
fi
# if [ "$DISTRIBUTION" = "redhat" ] || [ "$DISTRIBUTION" = "arch" ]; then
if command -v bat >/dev/null 2>&1; then
    # echo "Program 'bat' exists"
    alias cat='bat'
fi
# elif command -v batcat > /dev/null 2>&1; then
#   echo "Program 'bat' exists"
#   alias cat='batcat'
# # fi
# fi
# alias cat="bat"
# alias emacs="emacs -nw"
alias imgcatsh="~/useful_scripts/imgcat.sh"
# for zoxide
eval "$(zoxide init bash)"

# check z exists
if command -v z >/dev/null 2>&1; then
    # echo "Program 'z' exists"
    # Change directory aliases
    alias cd='z'
    alias home='z ~'
    alias cd..='z ..'
    alias ..='z ..'
    alias ...='z ../..'
    alias ....='z ../../..'
    alias .....='z ../../../..'
    # cd into the old directory
    alias bd='z "$OLDPWD"'
    alias new_d="z $(ls -td --color=never * | head -n 1)"

else
    # echo "Program 'z' does not exist"
    # Change directory aliases
    alias home='cd ~'
    alias cd..='cd ..'
    alias ..='cd ..'
    alias ...='cd ../..'
    alias ....='cd ../../..'
    alias .....='cd ../../../..'
    # cd into the old directory
    alias bd='cd "$OLDPWD"'
    alias new_d="cd $(ls -td --color=never * | head -n 1)"

fi

# Alias's for multiple directory listing commands
alias la='ls -Alh'                # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
if command -v lsd >/dev/null 2>&1; then
    alias ld='lsd -aFh --color=always'  # add colors and file type extensions
    alias ll='lsd -alFh --color=always' # add colors and file type extensions
    alias tree='lsd -aFh --color=always --tree'
else
    alias ld='ls -aFh --color=always'  # add colors and file type extensions
    alias ll='ls -alFh --color=always' # add colors and file type extensions
fi
# alias ld='lsd -aFh --color=always' # add colors and file type extensions
# alias ll='lsd -alFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh'      # sort by extension
alias lk='ls -lSrh'      # sort by size
alias lc='ls -ltcrh'     # sort by change time
alias lu='ls -lturh'     # sort by access time
alias lr='ls -lRh'       # recursive ls
alias lt='ls -ltrh'      # sort by date
alias lm='ls -alh |more' # pipe through 'more'
alias lw='ls -xAh'       # wide listing format
# alias ll='ls -Fls'                # long listing format
alias labc='ls -lap'             # alphabetical sort
alias lf="ls -l | egrep -v '^d'" # files only
alias ldir="ls -l | egrep '^d'"  # directories only
alias lla='ls -Al'               # List and Hidden Files
alias las='ls -A'                # Hidden Files
alias lls='ls -l'                # List

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"
# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

# Show open ports
alias openports='netstat -nape --inet'

# Alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# SHA1
alias sha1='openssl sha1'

alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'

# KITTY - alias to be able to use kitty features when connecting to remote servers(e.g use tmux on remote server)

alias kssh="kitty +kitten ssh"
# Function to check if running in WSL
check_wsl() {
    if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
        # echo "Running in WSL"
        alias wssh="wezterm.exe ssh"
    else
        # echo "Not running in WSL"
        alias wssh="wezterm ssh"
    fi
}

# Run the function
check_wsl

# alias to cleanup unused docker containers, images, networks, and volumes

alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '

# Enable history search with up and down arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi
FNM_PATH="/home/mylordtome/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env)"
fi
# for cargo
. "$HOME/.cargo/env"
# For linuxbrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# colored GCC warnings and errors
export COLORTERM=truecolor

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export GDK_BACKEND=wayland

gcom() {
    git add .
    git commit -m "$1"
}
lazyg() {
    git add .
    git commit -m "$1"
    git push
}
sessionize_script=~/dotfiles/bash/custom-scripts/sessionize.sh
# windower_dash_script=$HOME/dotfiles/bash/custom-scripts/windower_dash.sh

if [ -f "$sessionize_script" ]; then
    # echo "dash not found"
    if [ ! -x "$sessionize_script" ]; then
        chmod +x "$sessionize_script"
    fi
    # bind -x '"\C-t":{ $sessionize_script }'
    # bind -x '"\C-t":"$sessionize_script"'
    # ble-bind -x '"\C-t":"$sessionize_script"'
    # ble-bind -x '"\C-t": $sessionize_script'
    bind -x '"\C-f": $sessionize_script'
else
    echo "Sessionize script not found"
fi
# if command -v dash > /dev/null 2>&1; then
#     if [ -f "$windower_dash_script" ]; then
#         if [ ! -x "$windower_dash_script" ]; then
#             chmod +x "$windower_dash_script"
#         fi
#         bind -x '"\C-f": dash $HOME/dotfiles/bash/custom-scripts/windower_dash.sh'
#     fi
# elif [ -f "$sessionize_script" ]; then
#     echo "dash not found"
#     if [ ! -x "$sessionize_script" ]; then
#         chmod +x "$sessionize_script"
#     fi
#     # bind -x '"\C-t":{ $sessionize_script }'
#     # bind -x '"\C-t":"$sessionize_script"'
#     # ble-bind -x '"\C-t":"$sessionize_script"'
#     # ble-bind -x '"\C-t": $sessionize_script'
#     bind -x '"\C-f": $sessionize_script'
# else
#     echo "Sessionize script not found"
# fi
# #!/bin/bash
#
# # Function to check if running in WSL
# check_wsl() {
#     if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
#         # echo "Running in WSL"
#         bind '"\C-w": clear'
#     else
#         echo "Not running in WSL"
#     fi
# }
#
# # Run the function
# check_wsl
# usage: ex [file]
# from http://www.gitlab.com/dwt1/
function ex {
    if [ -z "$1" ]; then
        # display usage if no parameters given
        echo "Usage: ex <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    else
        for n in "$@"; do
            if [ -f "$n" ]; then
                case "${n%,}" in
                *.cbt | *.tar.bz2 | *.tar.gz | *.tar.xz | *.tbz2 | *.tgz | *.txz | *.tar)
                    tar xvf "$n"
                    ;;
                *.lzma) unlzma ./"$n" ;;
                *.bz2) bunzip2 ./"$n" ;;
                *.cbr | *.rar) unrar x -ad ./"$n" ;;
                *.gz) gunzip ./"$n" ;;
                *.cbz | *.epub | *.zip) unzip ./"$n" ;;
                *.z) uncompress ./"$n" ;;
                *.7z | *.arj | *.cab | *.cb7 | *.chm | *.deb | *.dmg | *.iso | *.lzh | *.msi | *.pkg | *.rpm | *.udf | *.wim | *.xar)
                    7z x ./"$n"
                    ;;
                *.xz) unxz ./"$n" ;;
                *.exe) cabextract ./"$n" ;;
                *.cpio) cpio -id <./"$n" ;;
                *.cba | *.ace) unace x ./"$n" ;;
                *)
                    echo "ex: '$n' - unknown archive method"
                    return 1
                    ;;
                esac
            else
                echo "'$n' - file does not exist"
                return 1
            fi
        done
    fi
}
### SET MANPAGER
### Uncomment only one of these!

### "nvim" as manpager
# export MANPAGER="nvim --clean +Man!"
# export MANPAGER="vi +MANPAGER +Man!"
# change your default USER shell
# alias tobash="sudo chsh $USER -s /bin/bash && echo 'Log out and log back in for change to take effect.'"  # already set to bash
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Log out and log back in for change to take effect.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Log out and log back in for change to take effect.'"

if command -v tmux &>/dev/null; then
    bind -x '"\C-w": clear'
    bind '"\C-g": "\C-j"'
    bind '"\ek": "\C-k"'
fi
if [ -f ~/.local/share/blesh/ble.sh ]; then
    source ~/.local/share/blesh/ble.sh
fi
# if [ -f ~/ble_colors.sh ]; then
#     . ~/ble_colors.sh &
# fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH=$PATH:$HOME/go/bin

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# # Pre-write a command in the terminal after loading .bashrc
# if [ -z "$PRE_WRITTEN_COMMAND_DONE" ]; then
#     export PRE_WRITTEN_COMMAND_DONE=1
#     # echo -n "tmux" && read -s -n 1
#     printf "'\e[1;32m'\e[7m'"
# fi
# function y_z() {
#     local tmp="$(mktemp -t "yazi-cwd-XXXXXX")" cwd
#     yazi "$@" --cwd-file="$tmp"
#     if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
#         cd -- "$cwd"
#     fi
#     \rm -f -- "$tmp"
# }
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    \rm -f -- "$tmp"
}
# export NODE_COMPILE_CACHE=~/.cache/nodejs-compile-cache
export PATH="$HOME/.local/bin:$PATH"
