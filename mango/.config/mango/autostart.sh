#!/usr/bin/env bash

set +e

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots >/dev/null 2>&1

prime-run dms run >/dev/null 2>&1 &
/usr/lib/polkit-kde-authentication-agent-1 >/dev/null 2>&1 &
xrdb ~/.Xresources >/dev/null 2>&1 &
echo "Xft.dpi: 120" | xrdb -merge >/dev/null 2>&1 &
# killall hypridle & hypridle
bash -c "wl-paste --watch cliphist store &" >/dev/null 2>&1 &
wlsunset >/dev/null 2>&1 &
elephant >/dev/null 2>&1 &
copyq --start-server >/dev/null 2>&1 &
flameshot >/dev/null 2>&1 &
walker --gapplication-service >/dev/null 2>&1 &
wayscriber --daemon >/dev/null 2>&1 &
kwalletd6 >/dev/null 2>&1 &
prime-run ghostty >/dev/null 2>&1 &
prime-run zen >/dev/null 2>&1 &
prime-run librewolf >/dev/null 2>&1 &
