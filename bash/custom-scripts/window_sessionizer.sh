#!/usr/bin/env bash

# The script is meant to be used as a sessionizing custom command for my configuration.
# --------------------------------------------------------------------------------
# This script is meant to be used with the following packages:
#   - tmux
#   - fzf
#   - find or fd (fd is faster)

# Function to list directories with fzf

create_tmux_session_or_window() {
  local select_session_file="$HOME/dotfiles/bash/custom-scripts/sessions.txt"
  local selected_dir
  local selected_session
  local session_select=" sessions"
  local used=0

  if [ ! -f "$session_file" ]; then
    touch "$session_file"
  fi

  query_prompt_fd_or_find=$(command -v fd &> /dev/null && "fd . -H --type d --type f ~" || "find ~ -type d -o -type f 2>/dev/null")
  query_prompt_1_sed_or_awk=$(command -v sed &> /dev/null && "sed "s|$HOME|~|"" || "awk -v home="$HOME" '{gsub(home, "~"); print}'")
  query_prompt_2_sed_or_awk=$(command -v sed &> /dev/null && "sed "s|~|$HOME|"" || "awk -v home="$HOME" '{gsub("~", home); print}'")

  select_dir() {
    if ! command -v fzf &> /dev/null; then
          echo "Error: 'fzf' is not installed. Please install fzf and try again." >&2
          exit 1
    fi
    if [ "$used" == 1 ]; then
      session_select=""
    fi
    selected_dir=$((eval "$session_select";eval "$query_prompt_fd_or_find") | eval "$query_prompt_1_sed_or_awk" | fzf --prompt="  Which directory are you looking for?   " --layout=reverse --height=~75% --border --exit-0 | eval "$query_prompt_2_sed_or_awk")
    echo "$selected_dir"
    used=$((1+$used))
  }
  select_dir
  check_session() {
    local session="$1"
    if [ -z "$session" ]; then
      echo "Error: No session name provided."
      return 1 
    fi
    # Check if the session already exists
    if tmux has-session -t "$session" 2>/dev/null; then
      echo "Session '$session' already exists. No action taken."
    else
      # Create a new session in the background
      tmux new-session -d -s "$session"
      echo "Session '$session' created in the background."
    fi
  }
  open_session() {
    if [ "$selected_dir" == " sessions" ] ; then
      selected_session=$(cat "$select_session_file" | fzf --prompt=" Which session are you looking for?   " --layout=reverse --height=~75% --border --exit-0 --print-query)
      local terminal_output=$(cat)
      local sed_or_awk=$(command -v sed &> /dev/null && "sed -n 1p" || "awk 'NR==1'")
      local sed_or_awk_s=$(command -v sed &> /dev/null && "sed -n 2p" || "awk 'NR==2'")
      local line1=$(echo "$terminal_output" | eval "$sed_or_awk")
      local line2=$(echo "$terminal_output" | eval "$sed_or_awk_s")

      if ! grep -qxF "$line1" "$select_session_file"; then
        echo "$line1" >> "$select_session_file"
        if command -v sed &> /dev/null; then
          sed -i '/^$/d' $select_session_file
        elif command -v awk &> /dev/null; then
          awk 'NF' "$select_session_file"
        fi
        tmux new-session -d -s "$line1" #create new session in the background
      else
        tmux new-session -d -s "$line2" #create new session in the background
      fi
    fi
  }
  open_session
}
