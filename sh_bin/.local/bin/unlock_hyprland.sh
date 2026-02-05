#!/usr/bin/env bash
pidof hyprlock && killall -9 hyprlock
hyprctl --instance $1 'keyword misc:allow_session_lock_restore=1'
hyprctl --instance $1 'dispatch exec hyprlock'
