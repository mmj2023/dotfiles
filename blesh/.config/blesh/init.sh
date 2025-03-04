# blerc

function blerc/define-sabbrev-branch {
  function blerc/sabbrev-git-branch {
    ble/util/assign-array COMPREPLY "git branch | sed 's/^\*\{0,1\}[[:space:]]*//'" 2>/dev/null
  }
  ble-sabbrev -m '\branch'=blerc/sabbrev-git-branch
}
blehook/eval-after-load complete blerc/define-sabbrev-branch

function blerc/define-sabbrev-commit {
  ble/color/defface blerc_git_commit_id fg=63
  ble/complete/action#inherit-from blerc_git_commit_id word
  function ble/complete/action:blerc_git_commit_id/init-menu-item {
    local ret
    ble/color/face2g blerc_git_commit_id; g=$ret
  }
  function blerc/sabbrev-git-commit {
    bleopt sabbrev_menu_style=desc-raw
    bleopt sabbrev_menu_opts=enter_menu

    local format=$'%h \e[1;32m(%ar)\e[m %s - \e[4m%an\e[m\e[1;33m%d\e[m'
    local arr; ble/util/assign-array arr 'git log --pretty=format:"$format"' &>/dev/null
    local line hash subject
    for line in "${arr[@]}"; do
      builtin read hash subject <<< "$line"
      ble/complete/cand/yield blerc_git_commit_id "$hash" "$subject"
    done
  }
  ble-sabbrev -m '\commit'='blerc/sabbrev-git-commit'
}
blehook/eval-after-load complete blerc/define-sabbrev-commit
# Note: If you want to combine fzf-completion with bash_completion, you need to
# load bash_completion earlier than fzf-completion.  This is required
# regardless of whether to use ble.sh or not.
source /nix/store/*-bash-completion*/etc/profile.d/bash_completion.sh

ble-import -d integration/fzf-completion
ble-import -d integration/fzf-key-bindings
bleopt prompt_ps1_final='$(starship module character)'
# function set_win_title(){
#     echo -ne "\033]0; YOUR_WINDOW_TITLE_HERE \007"
# }
# starship_precmd_user_func="set_win_title"
# Enable vi mode
set -o vi
# ble-bind -f 'C-r' 'ble-edit/history/search-backward'
# ble-bind -f 'C-s' 'ble-edit/history/search-forward'
# ble-bind -f 'C-p' 'history-prefix-search-backward'
# ble-bind -f 'C-n' 'history-prefix-search-forward'
# ble-bind -m vi_nmap 'k' history-search-backward
# ble-bind -m vi_nmap 'j' history-search-forward
