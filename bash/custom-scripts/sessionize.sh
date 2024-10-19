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
  # selected_dir=$(find . -type d -printf "%P\n" | fzf --height 40% --reverse --prompt "Select directory to sessionize> ")
  if command -v fd &> /dev/null; then
    if command -v sed &> /dev/null; then
      selected_dir=$(fd . --type d --type f ~ | sed "s|$HOME|~|" | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0 | sed "s|~|$HOME|") #Which directory to use fd . --type d --type f ~ | fzf
    elif command -v awk &> /dev/null; then
      selected_dir=$(fd . --type d --type f ~ | awk -v home="$HOME" '{gsub(home, "~"); print}' | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0 | awk -v home="$HOME" '{gsub("~", home); print}') #Which directory to use fd . --type d --type f ~ | fzf
    else
      echo "Error: sed and awk is not available or not working properly. Please check it."
      selected_dir=$(fd . --type d --type f ~ | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0) #Which directory to use fd . --type d --type f ~ | fzf
    fi
  elif command -v find &> /dev/null; then
    # selected_dir=$(find ~ -type d -o -type f 2>/dev/null | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0)
    if command -v sed &> /dev/null; then
      selected_dir=$(find ~ -type d -o -type f 2>/dev/null | sed "s|$HOME|~|" | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0 | sed "s|~|$HOME|") #Which directory to use fd . --type d --type f ~ | fzf
    elif command -v awk &> /dev/null; then
      selected_dir=$(find ~ -type d -o -type f 2>/dev/null | awk -v home="$HOME" '{gsub(home, "~"); print}' | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0 | awk -v home="$HOME" '{gsub("~", home); print}') #Which directory to use fd . --type d --type f ~ | fzf
    else
      echo "Error: sed and awk is not available or not working properly. Please check it."
      selected_dir=$(find ~ -type d -o -type f 2>/dev/null | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0) #Which directory to use fd . --type d --type f ~ | fzf
    fi
  # elif command -v ls &> /dev/null
  #   # selected_dir=$(ls -d ~ | fzf)
  #   echo "working on it"
  else
    echo "Error: Neither 'fd', 'fzf' is available. Please install one of them." >&2
    exit 1
  fi
  echo "$selected_dir"
}

# Check for existing tmux window
check_tmux_window() {
  local session
  local windows
  for session in $(tmux list-sessions -F '#S'); do
    for window in $(tmux list-windows -t "$session" -F '#W'); do
      if [ "$window" == "$1" ]; then
        if [ -z "$TMUX" ]; then
          tmux a -t "$session:$window"
        else
          tmux switch-client -t "$session:$window"
        fi
        return 0
      fi
    done
  done
  return 1
}

# Create a new tmux session/window
create_tmux_session_or_window() {
  local dir="$1"
  local dir_n=$(basename "$dir")
  if [ -z "$(tmux list-sessions)" ]; then
        tmux new-session -s "editing" -n "$dir_n" -c "$dir"
  else
        tmux new-window -t "$(tmux list-sessions -F '#S' | head -n 1)" -n "$dir_n" -c "$dir"
        if [ -z "$TMUX" ]; then
          tmux a -t "$(tmux list-sessions -F '#S' | head -n 1):$dir_n"
        else
          tmux switch-client -t "$dir_n"
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

  if [ -n "$selected_item" ]; then
    if [ -f "$selected_item" ]; then
      selected_dir=$(dirname "$selected_item")
    else
      selected_dir="$selected_item"
    fi
    dir_name=$(basename "$selected_dir")
    # dir_name=$(basename "$selected_dir")
    if ! check_tmux_window "$dir_name"; then
        create_tmux_session_or_window "$selected_dir"
    fi
  fi
}

main
