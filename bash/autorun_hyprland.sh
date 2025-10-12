#!/usr/bin/env bash
# hyprctl dispatch workspace 2
# prime-run zen & disown
# hyprctl dispatch exec "[workspace 2 silent] prime-run zen"
prime-run zen &
PID=$!
sleep 1
hyprctl dispatch movetoworkspace 2,pid:$PID
