#!/usr/bin/env bash

# browser=$(xdg-settings get default-web-browser)
#
# case $browser in
# google-chrome* | brave-browser* | microsoft-edge* | opera* | vivaldi* | helium-browser* | app.zen_browser.zen*) ;;
# *) browser="chromium.desktop" ;;
# esac

# exec setsid $(sed -n 's/^Exec=\([^ ]*\).*/\1/p' {~/.local,~/.nix-profile,/usr}/share/applications/$browser 2>/dev/null | head -1) --app="$1" "${@:2}"
# exec setsid ~/Applications/squashfs-root/AppRun --app="$1" "${@:2}"
exec setsid ~/Applications/squashfs-root/AppRun --app="$1" "${@:2}"
