#!/usr/bin/env bash
REG_FILE="${1:?Usage: $0 <path-to-generated.reg>}"

SYSTEM_WINE="$(command -v wine)"
AFFINITY_WINE="/home/mdmmj/.AffinityLinux/ElementalWarriorWine/bin/wine"
AFFINITY_WINE2="/home/mdmmj/.AffinityLinux/Wine-Switch/11.12/bin/wine"
AFFINITY_WINE3="/home/mdmmj/.AffinityLinux/Wine-Switch/11.0/bin/wine"

resolve_wine() {
    local wine_bin=""
    for candidate in "$AFFINITY_WINE" "$AFFINITY_WINE2" "$AFFINITY_WINE3" "$SYSTEM_WINE"; do
        if [[ -x "$candidate" ]]; then
            wine_bin="$candidate"
            break
        fi
    done
    echo "${wine_bin:-$SYSTEM_WINE}"
}

apply_to() {
    local prefix="$1"
    local wine_bin
    wine_bin="$(resolve_wine)"
    if [[ -f "$prefix/user.reg" ]]; then
        echo "Applying theme to $prefix using $wine_bin"
        WINEPREFIX="$prefix" "$wine_bin" regedit "$REG_FILE" 2>/dev/null
        # WINEPREFIX="$prefix" "$wine_bin" regedit "$REG_FILE"
    fi
}

apply_to "/home/mdmmj/.wine"
apply_to "/home/mdmmj/affinity-wine"
apply_to "/home/mdmmj/.AffinityLinux/pfx"
