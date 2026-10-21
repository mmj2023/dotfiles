#!/usr/bin/env bash
# kmscon/regen-theme.sh — re-run DMS's matugen so the kmscon palette in
# /etc/kmscon/kmscon.conf matches the current wallpaper.
#
# matugen regenerates ~/.cache/kmscon/matugen-palette.conf and its post_hook
# (pkexec ~/dotfiles/kmscon/dms/libexec/kmscon-matugen-apply) splices the
# DMS MATUGEN PALETTE block into /etc/kmscon/kmscon.conf.
#
# The palette is therefore ALWAYS dynamic — never edit /etc/kmscon/kmscon.conf
# by hand.
set -euo pipefail

WALLPAPER=$(dms ipc call wallpaper get | tr -d '"')
STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/DankMaterialShell"
SHELL_DIR=$(ls -d /run/user/"$(id -u)"/danklinux-shell/* | head -1)

dms matugen queue \
	--state-dir "$STATE_DIR" \
	--shell-dir "$SHELL_DIR" \
	--config-dir "$HOME/.config" \
	--kind image \
	--value "$WALLPAPER" \
	--mode dark \
	--icon-theme "System Default" \
	--matugen-type scheme-content
