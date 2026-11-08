# Personal agent guidance

These are user-specific requirements for every coding agent working on this
machine. Repository-specific instructions remain authoritative for that
repository and should be followed in addition to this file.

## Hyprland live-session safety

Before any Hyprland configuration or live-session work, read
[`skills/hyprland-live-safety/SKILL.md`](skills/hyprland-live-safety/SKILL.md).
**Do not run any `hyprctl` command or perform a live compositor action unless
the user has explicitly approved that specific invocation/action.** This
includes read-only queries, reloads, dispatches, and runtime Lua evaluation.
Do not treat prior permission as ongoing permission.

**This host's Hyprland configuration and control APIs are Lua-based.** Do not
solve Hyprland tasks using legacy configuration/dispatcher syntax copied from
older versions; treat that syntax as deprecated for this setup. Use the
current Lua-bound API and syntax, but do not assume its names or signatures
are stable: they can change between Hyprland versions.

Find the right API through offline documentation and source for the installed
version, not by guessing. Do not enumerate or introspect C-backed objects,
probe metatables, or explore APIs against the running compositor: such
path-finding has crashed Hyprland and can terminate the user's desktop. Avoid
live exploration by default. Only if it is genuinely necessary, first ask the
user for explicit permission for the exact command/action; absent that
permission, stick to offline validation and report the uncertainty. A syntax
check alone does not establish runtime safety.

## MyQuickshell behavior contract

For MyQuickshell bar changes, read
[`skills/myquickshell-bar-and-notes/SKILL.md`](skills/myquickshell-bar-and-notes/SKILL.md)
and the repository's root `AGENTS.md`.

- A fullscreen window on a normal workspace should be able to cover the bar.
  Do not raise the bar merely because fullscreen is active.
- Raise the bar above fullscreen only on the affected monitor while a special
  workspace is visible over a regular workspace that is actively fullscreen.
  Once the special workspace is hidden, restore normal fullscreen behavior.
- Hide the bar when a window on the visible special workspace itself is
  fullscreen.
- Keep this behavior per-monitor; do not make a special workspace on one
  output change the bar layer on another output.
- The Notes shortcut is Super+Shift+N and should open MyQuickshell Notes, with
  keyboard focus in the editor and session/options persisted across restarts.
- Prefer focused changes that preserve the existing shell UX. Do not expand
  the special-workspace exception into a general always-on-top bar policy.
