#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

link_if_missing() {
    local source="$1"
    local target="$2"
    local source_real

    source_real="$(readlink -f -- "$source")"
    mkdir -p -- "$(dirname -- "$target")"

    if [[ -L "$target" ]]; then
        if [[ "$(readlink -f -- "$target")" == "$source_real" ]]; then
            return
        fi
        printf 'Refusing to replace unrelated symlink: %s\n' "$target" >&2
        return 1
    fi

    if [[ -e "$target" ]]; then
        printf 'Refusing to replace existing file or directory: %s\n' "$target" >&2
        return 1
    fi

    ln -s -- "$source_real" "$target"
}

link_if_missing "$root/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link_if_missing "$root/AGENTS.md" "$HOME/.gemini/GEMINI.md"
link_if_missing "$root/skills/hyprland-live-safety" \
    "$HOME/.config/opencode/skills/hyprland-live-safety"
link_if_missing "$root/skills/myquickshell-bar-and-notes" \
    "$HOME/.config/opencode/skills/myquickshell-bar-and-notes"
