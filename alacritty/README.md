# Terminal opacity toggle (kitty / alacritty / ghostty)

One shared script flips background opacity `0 <-> 1` for every terminal. Colors are
never hardcoded — they come from DMS's matugen run.

## Trigger sources

| Terminal  | Ctrl+Alt+B inside it | Mechanism |
|-----------|---------------------|-----------|
| kitty     | native `map ctrl+alt+b launch --type=background` in kitty.conf | script rewrites the managed block in `kitty.conf`; kitty's own config watcher (`kitten __watch_conf__`) applies it live |
| alacritty | native `[[keyboard.bindings]]` `command` exec in alacritty.toml | script rewrites the managed block in `alacritty.toml`; alacritty's live config reload applies it |
| ghostty   | fallthrough: no binding → Ctrl+Alt+B reaches the shell (zsh binding flips everything) | script rewrites `~/.cache/terminal-opacity/ghostty.conf`; applied by ghostty's **built-in** `Ctrl+Shift+,` (`reload_config`) — config needs no custom keybinds |

- zsh: `~/dotfiles/zsh/.zshrc` binds Ctrl+Alt+B (both legacy and kitty/CSI-u encodings)
  and provides a `toggle-terminal-opacity` command — this is what catches the
  ghostty fallthrough (and any prompt anywhere).
- Script: `~/dotfiles/sh_bin/.local/bin/toggle-terminal-opacity` (symlinked to
  `~/.local/bin/`). State: `~/.cache/terminal-opacity/mode`.

## DMS matugen side

- `dotfiles/matugen/.config/matugen/templates/terminal-opacity-theme.sh` renders
  `~/.cache/terminal-opacity/theme.sh` with `TRANSPARENT_BG` (theme background) and
  `OPAQUE_BG` (`surface_container`) on every DMS theme generation. The script falls
  back to parsing `~/.config/hypr/dms/matugen_colors.lua` while it hasn't been generated yet.
- Swap the color backend by only editing that template / the script's `load_colors`.
- Alacritty is themed natively by DMS: `~/.config/alacritty/dank-theme.toml`
  (imported from `alacritty.toml`). Enable "Terminals" matugen templates in DMS
  Settings > Theme & Colors if it stops being generated.

## Managed blocks

Files' `--- BEGIN terminal-opacity-toggle ... END ---` blocks are rewritten by the
script — don't edit inside them; everything else is yours.
