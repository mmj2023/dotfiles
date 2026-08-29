#!/usr/bin/env zsh

# --- Interactive Shell Check ---
[[ $- != *i* ]] && return

KEYTIMEOUT=50

# Disable flow control (Ctrl+S/XOFF) for keybindings
# stty -ixon 2>/dev/null

# --- Distribution Detection ---
distribution() {
  local dtype="unknown"
  if [[ -r /etc/os-release ]]; then
    source /etc/os-release
    case $ID in
      fedora|rhel|centos) dtype="redhat" ;;
      sles|opensuse*) dtype="suse" ;;
      ubuntu|debian) dtype="debian" ;;
      gentoo) dtype="gentoo" ;;
      arch|manjaro) dtype="arch" ;;
      slackware) dtype="slackware" ;;
      *)
        if [[ -n $ID_LIKE ]]; then
          case $ID_LIKE in
            *fedora*|*rhel*|*centos*) dtype="redhat" ;;
            *sles*|*opensuse*) dtype="suse" ;;
            *ubuntu*|*debian*) dtype="debian" ;;
            *gentoo*) dtype="gentoo" ;;
            *arch*) dtype="arch" ;;
            *slackware*) dtype="slackware" ;;
          esac
        fi
        ;;
    esac
  fi
  echo $dtype
}
DISTRIBUTION=$(distribution)

# --- IP Address Lookup ---
alias whatismyip="whatsmyip"
whatsmyip() {
  if command -v ip &>/dev/null; then
    echo -n "Internal IP: "
    ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
  else
    echo -n "Internal IP: "
    ifconfig wlan0 | grep "inet " | awk '{print $2}'
  fi
  echo -n "External IP: "
  curl -s ifconfig.me
}

# --- Startup Visuals (outside tmux) ---
if [[ -z $TMUX ]]; then
  if command -v krabby &>/dev/null; then
    krabby random
  fi
  if command -v fastfetch &>/dev/null; then
    if [[ $TERM == "xterm-kitty" ]]; then
      fastfetch
    else
      fastfetch -c ~/.config/fastfetch/fallback_fasfetch.jsonc
      alias fastfetch="fastfetch -c ~/.config/fastfetch/fallback_fasfetch.jsonc"
    fi
  fi
  if command -v colorscript &>/dev/null; then
    colorscript random
  fi
fi

# --- System Version ---
ver() {
  local dtype=$(distribution)
  case $dtype in
    "redhat")
      [[ -s /etc/redhat-release ]] && cat /etc/redhat-release || cat /etc/issue
      uname -a
      ;;
    "suse") cat /etc/SuSE-release ;;
    "debian") lsb_release -a ;;
    "gentoo") cat /etc/gentoo-release ;;
    "arch") cat /etc/os-release ;;
    "slackware") cat /etc/slackware-version ;;
    *)
      [[ -s /etc/issue ]] && cat /etc/issue || { echo "Error: Unknown distribution"; return 1 }
      ;;
  esac
}

# --- Global Definitions & Completion ---
[[ -f /etc/zshrc ]] && source /etc/zshrc

# Zsh completion system
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# --- Shell Options & History ---
setopt NO_BEEP
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

HISTSIZE=50000
SAVEHIST=100000
HISTFILE=~/.zsh_history
HISTTIMEFORMAT="%F %T"

# --- XDG Base Directory ---
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# --- Colors & Display ---
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

# Man page colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Prefer ripgrep for grep
if command -v rg &>/dev/null; then
  alias grep='rg'
else
  alias grep="/usr/bin/grep --color=auto"
fi

# Alert for long commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# --- Aliases ---
alias plasma-wifi='QT_QUICK_CONTROLS_STYLE=org.kde.desktop plasmawindowed org.kde.plasma.networkmanagement'
alias cp='cp -i'
alias mv='mv -i'
alias rmd='\rm --recursive --force --verbose'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias cls='clear'
alias apt-get='sudo apt-get'

command -v freshclam >/dev/null 2>&1 && alias freshclam='sudo freshclam'
command -v multitail >/dev/null 2>&1 && alias multitail='multitail --no-repeat -c'
command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'

if command -v nvim &>/dev/null; then
  alias ebrc='nvim ~/.zshrc'
  alias vi='nvim'
  alias vim='nvim'
  alias svi='sudo vi'
  alias vis='nvim "+set si"'
  [[ -d ~/.config/nvchadnvim ]] && alias nvvi="NVIM_APPNAME=nvchadnvim nvim"
  [[ -d ~/.config/lazynvim ]] && alias lavi="NVIM_APPNAME=lazynvim nvim"
  [[ -d ~/.config/astronvim ]] && alias asvi="NVIM_APPNAME=astronvim nvim"
  [[ -d ~/.config/freshnvim ]] && {
    alias frvi="NVIM_APPNAME=freshnvim nvim"
    alias v="NVIM_APPNAME=freshnvim nvim"
    alias sv="sudo -E NVIM_APPNAME=freshnvim nvim"
  }
  [[ -f ~/.local/bin/lvim ]] && alias luvi="~/.local/bin/lvim"
  alias freshnvim='NVIM_APPNAME=freshnvim nvim'
  export EDITOR=nvim
  export VISUAL=nvim
fi

alias less='less -R'

[[ -f ~/.blerc.sh ]] && alias b_c="source ~/.blerc.sh"

command -v x86_64-w64-mingw32-gcc >/dev/null 2>&1 && alias wingcc="x86_64-w64-mingw32-gcc"

if command -v xsel >/dev/null 2>&1; then
  alias xcopy="xsel --input --clipboard"
  alias xpaste="xsel --output --clipboard"
fi

command -v nala >/dev/null 2>&1 && alias apt="sudo nala"
command -v bat >/dev/null 2>&1 && alias cat='bat'

alias imgcatsh="~/useful_scripts/imgcat.sh"

# Directory listing
alias la='ls -Alh'
alias ls='ls -aFh --color=always'
if command -v lsd >/dev/null 2>&1; then
  alias lsd='lsd -aFh --color=always'
  alias ll='lsd -alFh --color=always'
  alias tree='lsd -aFh --color=always --tree'
else
  alias lsd='ls -aFh --color=always'
  alias ll='ls -alFh --color=always'
fi
alias lx='ls -lXBh'
alias lk='ls -lSrh'
alias lc='ls -ltcrh'
alias lu='ls -lturh'
alias lr='ls -lRh'
alias lt='ls -ltrh'
alias lm='ls -alh | more'
alias lw='ls -xAh'
alias labc='ls -lap'
alias lf="ls -l | grep -v '^d'"
alias ldir="ls -l | grep '^d'"
alias lla='ls -Al'
alias las='ls -A'
alias lls='ls -l'

# Chmod aliases
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# History & process search
alias h="history | grep "
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# File counting
alias countfiles="for t in files links directories; do echo \$(find . -type \${t:0:1} | wc -l) \$t; done 2> /dev/null"

# Command type
alias checkcommand="type -t"

# File finding
if command -v fd &>/dev/null; then
  alias f="fd --type f"
  alias d="fd --type d"
else
  alias f="find . | grep "
fi

# Ports & reboot
alias openports='netstat -nape --inet'
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Disk space
alias diskspace="du -S | sort -n -r | more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Logs
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# SHA1
alias sha1='openssl sha1'

alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'

# Kitty SSH
alias kssh="kitty +kitten ssh"

# WSL detection
check_wsl() {
  if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
    alias wssh="wezterm.exe ssh"
  else
    alias wssh="__NV_DISABLE_EXPLICIT_SYNC=1 wezterm ssh"
  fi
}
check_wsl
alias wezterm="__NV_DISABLE_EXPLICIT_SYNC=1 wezterm"

# Docker cleanup
alias docker-clean='docker container prune -f; docker image prune -f; docker network prune -f; docker volume prune -f'

# --- History Search with Arrow Keys ---
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# --- Bash Aliases File ---
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

# --- Starship Prompt ---
command -v starship &>/dev/null && eval "$(starship init zsh)"

# --- FNM (Fast Node Manager) ---
FNM_PATH="$HOME/.local/share/fnm"
[[ -d "$FNM_PATH" ]] && {
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd --shell zsh)"
}

# --- Cargo/Rust ---
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# --- Linuxbrew ---
[[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/:$PATH"

# --- Git Aliases & Functions ---
command -v git &>/dev/null && alias gits='git status'

gcom() {
  git add . && git commit -m "$1"
}

lazyg() {
  git add . && git commit -m "$1" && git push
}

# --- Sesh + FZF Integration ---
# if command -v sesh &>/dev/null; then
#   sesh_script() {
#     if [[ -z $TMUX ]]; then
#       if tmux has-session 2>/dev/null; then
#         tmux attach
#       else
#         tmux new-session
#         tmux attach
#       fi
#       return
#     fi
#
#     # sesh connect "$(
#     #   sesh list --icons | fzf-tmux -p 80%,70% \
#     #     --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
#     #     --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
#     #     --bind 'tab:down,btab:up' \
#     #     --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
#     #     --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
#     #     --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
#     #     --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
#     #     --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
#     #     --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
#     #     --preview-window 'right:55%' \
#     #     --preview 'sesh preview {}'
#     # )"
#   }
#  stty -ixon
#   zle -N sesh_script
#   # Bind Ctrl+S then T to sesh_script (matching bash)
#   bindkey "^ST" sesh_script
#   # bindkey "\C-sT" sesh_script
# fi
# --- Sesh + FZF Integration ---
# --- Sesh + FZF Integration ---


# -----

# stty -ixon
# if command -v sesh &>/dev/null; then
#   sesh_script() {
#     # Hand stdin, stdout, and stderr back to the real terminal
#     exec </dev/tty >/dev/tty 2>&1
#     zle -I
#
#     if [[ -z $TMUX ]]; then
#       if tmux has-session 2>/dev/null; then
#         tmux attach
#       else
#         tmux new-session
#       fi
#     # else
#     #   local session
#     #   session="$(
#     #     sesh list --icons | fzf-tmux -p 80%,70% \
#     #       --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
#     #       --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
#     #       --bind 'tab:down,btab:up' \
#     #       --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
#     #       --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
#     #       --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
#     #       --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
#     #       --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
#     #       --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
#     #       --preview-window 'right:55%' \
#     #       --preview 'sesh preview {}'
#     #   )"
#     #
#     #   [[ -n "$session" ]] && sesh connect "$session"
#     fi
#
#     zle reset-prompt
#   }
#
#   zle -N sesh_script
#   bindkey -M emacs "^S" sesh_script
#   bindkey -M vicmd "^S" sesh_script
#   bindkey -M viins "^S" sesh_script
#   # bindkey "^St" sesh_script
# fi

# ------------
# Disable flow control so Ctrl+S works
stty -ixon

tmux_widget() {
  if [[ -z "$TMUX" ]]; then
   zle push-line
   BUFFER="tmux attach-session 2>/dev/null || tmux new-session"
   zle accept-line
  fi
}

zle -N tmux_widget
bindkey -M emacs "^ST" tmux_widget
bindkey -M vicmd "^ST" tmux_widget
bindkey -M viins "^ST" tmux_widget


# --- Archive Extraction ---
ex() {
  if [[ -z $1 ]]; then
    echo "Usage: ex <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
  fi
  for n in "$@"; do
    if [[ -f $n ]]; then
      case ${n%,} in
        *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) tar xvf "$n" ;;
        *.lzma) unlzma ./"$n" ;;
        *.bz2) bunzip2 ./"$n" ;;
        *.cbr|*.rar) unrar x -ad ./"$n" ;;
        *.gz) gunzip ./"$n" ;;
        *.cbz|*.epub|*.zip) unzip ./"$n" ;;
        *.z) uncompress ./"$n" ;;
        *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar) 7z x ./"$n" ;;
        *.xz) unxz ./"$n" ;;
        *.exe) cabextract ./"$n" ;;
        *.cpio) cpio -id < ./"$n" ;;
        *.cba|*.ace) unace x ./"$n" ;;
        *) echo "ex: '$n' - unknown archive method"; return 1 ;;
      esac
    else
      echo "'$n' - file does not exist"
      return 1
    fi
  done
}

# --- Default Shell Aliases ---
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Log out and log back in for change to take effect.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Log out and log back in for change to take effect.'"
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Log out and log back in for change to take effect.'"

# --- Tmux Keybindings ---
if command -v tmux &>/dev/null; then
  bindkey '^W' clear-screen
  bindkey '^G' accept-line
  bindkey '^[k' kill-line
fi

# --- Yazi Integration ---
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [[ -n $cwd ]] && [[ $cwd != $PWD ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# --- Zoxide ---
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Zoxide aliases
alias cd='z'
alias home='z ~'
alias cd..='z ..'
alias ..='z ..'
alias ...='z ../..'
alias ....='z ../../..'
alias .....='z ../../../..'
alias bd='z "$OLDPWD"'
alias new_d='z $(ls -td --color=never * | head -n 1)'

# --- Paru/Yay FZF ---
command -v paru &>/dev/null && {
  alias parf="paru -Slq | fzf --multi --preview 'paru -Sii {1}' --preview-window=down:75% | xargs -ro paru -S --needed"
  alias yayf="yay -Slq | fzf --multi --preview 'paru -Sii {1}' --preview-window=down:75% | xargs -ro paru -S --needed"
  alias parr="paru -Qq | fzf --multi --preview 'paru -Qi {1}' --preview-window=down:75% | xargs -ro paru -Rns"
}
alias mingwgcc="x86_64-w64-mingw32-gcc"

# --- Carapace Completion ---
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
command -v carapace &>/dev/null && source <(carapace _carapace zsh)

# --- pkgfile command-not-found ---
[[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

# --- Mise (optional) ---
# eval "$(mise activate zsh)"

# --- Antigravity CLI ---
export PATH="/home/mdmmj/.local/bin:$PATH"

# --- Zsh Syntax Highlighting ---
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null \
  || source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null \
  || source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# --- Zsh Syntax Highlighting Theme (applied after plugin loads) ---
[[ -f ~/.config/zsh-syntax-highlighting/theme.zsh ]] && source ~/.config/zsh-syntax-highlighting/theme.zsh

# --- Zsh Autosuggestions ---
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null \
  || source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null \
  || source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# --- DMS Completion ---
command -v dms &>/dev/null && source <(dms completion zsh)

# --- Vi Mode (disabled; uncomment to enable) ---
# bindkey -v
# export KEYTIMEOUT=1
#
# # Better vi mode cursor
# function zle-keymap-select() {
#   case $KEYMAP in
#     vicmd) echo -ne '\e[1 q' ;;      # block cursor
#     viins|main) echo -ne '\e[5 q' ;; # beam cursor
#   esac
# }
# zle -N zle-keymap-select
#
# function zle-line-init() {
#   zle -K viins
#   echo -ne '\e[5 q'
# }
# zle -N zle-line-init

. "$HOME/.local/share/../bin/env"


# Added by Antigravity CLI installer
export PATH="/home/mdmmj/.local/bin:$PATH"

# --- FZF Keybindings ---
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
