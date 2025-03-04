#!/usr/bin/env bash
# --------------------------------------------------------------------------------------
# The script is meant to be used as a sessionizing custom command for my configuration.
# --------------------------------------------------------------------------------------
# This script is meant to be used with the following packages:
#   - tmux
#   - fzf
#   - find or fd

# Function to list directories with fzf
select_dir_file_item() {
  local session_file="$HOME/dotfiles/bash/custom-scripts/sessions.txt"
  local selected_dir
  local selected_session
  local selection_list
  local selection_list_add=" sessions"
  local used=0
  # local GREEN='\033[0;32m'
  if [ ! -f "$session_file" ]; then
    touch "$session_file"
  fi
  # selected_dir=$(find . -type d -printf "%P\n" | fzf --height 40% --reverse --prompt "Select directory to sessionize> ")
  fix_selected_session() {

    if [ "$used" == 1 ]; then
      selection_list_add=""
    fi

    if command -v fd &> /dev/null; then
      # selection_list=$(fd . -H --type d --type f ~)
      # selected_list=$(echo -e "sessions\n$selection_list")
      if command -v sed &> /dev/null; then
        selected_dir=$((echo -e "$selection_list_add";fd . -H --type d --type f ~) | sed "s|$HOME|~|" | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0 | sed "s|~|$HOME|") #Which directory to use fd . --type d --type f ~ | fzf
      elif command -v awk &> /dev/null; then
        selected_dir=$((echo "$selection_list_add";fd . -H --type d --type f ~) | awk -v home="$HOME" '{gsub(home, "~"); print}' | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0 | awk -v home="$HOME" '{gsub("~", home); print}') #Which directory to use fd . --type d --type f ~ | fzf
      else
        echo "Error: sed and awk is not available or not working properly. Please check it."
        selected_dir=$((echo "$selection_list_add";fd . -H --type d --type f ~) | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0) #Which directory to use fd . --type d --type f ~ | fzf
      fi
    elif command -v find &> /dev/null; then
      selection_list=$(find ~ -type d -o -type f 2>/dev/null)
      # selected_dir=$(find ~ -type d -o -type f 2>/dev/null | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0)
      if command -v sed &> /dev/null; then
        selected_dir=$((echo "$selection_list_add";find ~ -type d -o -type f 2>/dev/null) | sed "s|$HOME|~|" | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0 | sed "s|~|$HOME|") #Which directory to use fd . --type d --type f ~ | fzf
      elif command -v awk &> /dev/null; then
        selected_dir=$((echo "$selection_list_add";find ~ -type d -o -type f 2>/dev/null) | awk -v home="$HOME" '{gsub(home, "~"); print}' | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0 | awk -v home="$HOME" '{gsub("~", home); print}') #Which directory to use fd . --type d --type f ~ | fzf
      else
        echo "Error: sed and awk is not available or not working properly. Please check it."
        selected_dir=$((echo "$selection_list_add";find ~ -type d -o -type f 2>/dev/null) | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0) #Which directory to use fd . --type d --type f ~ | fzf
      fi
    # elif command -v ls &> /dev/null
    #   # selected_dir=$(ls -d ~ | fzf)
    #   echo "working on it"
    else
      echo "Error: Neither 'fd', 'fzf' is available. Please install one of them." >&2
      exit 1
    fi
    echo "$selected_dir"
    used=$((1+$used))
  }
  fix_selected_session
    if [ "$selected_dir" == " sessions" ] ; then
      selected_session=$(cat "$session_file" | fzf --prompt=" Which session are you looking for?   " --layout=reverse --height=~75% --border --exit-0 --print-query)
      if ! grep -qxF "$selected_session" "$session_file"; then
        echo "$selected_session" >> "$session_file"
        if command -v sed &> /dev/null; then
          sed '/^$/d' $session_file
          # awk 'NF' "$session_file"
        elif command -v awk &> /dev/null; then
          awk 'NF' "$session_file"
        fi
      fi
      fix_selected_session
      echo -e "$selected_dir\n$selected_session"
    else
      echo "$selected_dir"
    fi
}

# Check for existing tmux window
check_tmux_window() {
  local session
  local windows
  local dir="$1"
  local dir_n=$(basename "$dir")
  for session in $(tmux list-sessions -F '#S'); do
    for window in $(tmux list-windows -t "$session" -F '#W'); do
      if [ "$window" == "$1" ]; then
        if [ -z "$2" ]; then
          if [ -z "$TMUX" ]; then
            tmux a -t "$session:$window"
          else
            tmux switch-client -t "$session:$window"
          fi
          return 0
        else
          # tmux new-session -s "$2" -n "$dir_n" -c "$dir"
          return 1
        fi
      fi
    done
  done
  return 1
}

# Create a new tmux session/window
create_tmux_session_or_window() {
  local dir="$1"
  # local session_name="$2"
  if [ ! -z "$2" ]; then
    local session_name="$2"
  fi
  local dir_n=$(basename "$dir")
  if [ ! -z "$(tmux list-sessions)" ]; then
    if [ -z "$2" ]; then
      tmux new-session -s "editing" -n "$dir_n" -c "$dir"
    else
      tmux new-session -s "$2" -n "$dir_n" -c "$dir"
    fi
  else
    if [ -z "$2" ]; then
        tmux new-window -t "$(tmux list-sessions -F '#S' | head -n 1)" -n "$dir_n" -c "$dir"
        if [ -z "$TMUX" ]; then
          tmux a -t "$(tmux list-sessions -F '#S' | head -n 1):$dir_n"
        else
          tmux switch-client -t "$dir_n"
        fi
    fi
  fi
}

# the main function
main() {
  if ! command -v tmux &> /dev/null; then
        echo "Error: 'tmux' is not installed. Please install tmux and try again." >&2
        exit 1
  fi

  selected_item=$(select_dir_file_item)
  if command -v sed &> /dev/null; then
    selected_dir=$(echo "$selected_item" | sed -n '1p')
    selected_session=$(echo "$selected_item" | sed -n '2p')
  elif command -v awk &> /dev/null; then
    selected_dir=$(echo "$selected_item" | awk 'NR==1')
    selected_session=$(echo "$selected_item" | awk 'NR==2')
  fi

  if [ -n "$selected_dir" ]; then
    if [ -f "$selected_dir" ]; then
      selected_dir=$(dirname "$selected_item")
    else
      selected_dir="$selected_dir"
    fi
    dir_name=$(basename "$selected_dir")
    # dir_name=$(basename "$selected_dir")
    if ! check_tmux_window "$selected_dir" "$selected_session"; then
        create_tmux_session_or_window "$selected_dir" "$selected_session"
    fi
  fi
}

main
