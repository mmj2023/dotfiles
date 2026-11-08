---
name: hyprland-live-safety
description: Use this skill before running hyprctl, editing Hyprland/HyprLua config, or interacting with the live compositor. Ask before each specific live action; verify its syntax offline first. Required for work on ~/dotfiles/hyprland, ~/.config/hypr, hyprctl, or hl.* Lua dispatchers.
---

# Hyprland live-session safety

## Lua API and deprecated syntax

This host's Hyprland configuration and control APIs are Lua-based. Do not use
legacy configuration or dispatcher syntax from older Hyprland versions for
this setup; treat it as deprecated. Solve tasks with the current Lua-bound
API and syntax.

The Lua API is version-sensitive and some names/signatures change. Discover
the appropriate API from documentation and source matching the installed
version, checked offline. Do not guess from old examples or assume a method
signature is still current. Do not perform runtime API discovery against the
live compositor by enumerating objects, probing metatables, or trying
candidate calls: those techniques have caused Hyprland to crash on this
machine. Diagnose through offline docs/source first; use a live action only
when needed to complete the user's task.

## ASK BEFORE LIVE HYPRLAND ACTIONS

**Before any command or action that interacts with the live Hyprland
compositor, ask the user for permission for the specific action.** This
includes read-only queries, `hyprctl` commands, Lua evaluation, reloads,
dispatches, and runtime setting changes. State the exact command/action and
its expected effect; wait for explicit approval before running it. A general
request to work on Hyprland is not permission to perform an unspecified live
action.

Once the user approves the stated action, carry it out only after verifying
its syntax and effects against offline documentation/source for the installed
version. Do not ask again for the same approved invocation, but ask again
before materially different live actions. Editing configuration files does
not authorize reloading or otherwise acting on the live compositor. If
approval is declined or unavailable, stick to offline inspection/validation.

## Recorded runtime hazards

- At the time these notes were recorded, this host ran Hyprland 0.56.x with a
  **Lua config engine**. `hyprctl repl` / `hyprctl eval` execute Lua at runtime
  in the compositor process. The exact version may have changed; check the
  installed-version docs offline before relying on version-specific details.
- A crashing eval doesn't just error — it **aborts Hyprland**, killing the
  user's whole desktop with every open application.
- Verified crash: `~/.cache/hyprland/hyprlandCrashReport4395.txt`
  (signal 6/ABRT, `std::__throw_bad_any_cast()` thrown from the Lua bridge
  after `pairs(getmetatable(window_object).__index)`).
- **A syntax check (`luac -p`) is NOT a safety guarantee.** Valid-Lua code can
  still crash at runtime when calling into C-backed internals.
- An empty `hyprctl configerrors -j` after reload also does NOT prove bind
  safety — semantic/runtime issues surface when the bind fires, not at parse.

## Banned patterns (known to crash)

1. **`pairs(...)` / `for k,v in pairs(...)` over anything C-backed**
   (metatables of `hl.*` objects, `getmetatable(obj).__index` when it is a
   function, userdata tables). `#0` cause of crash report 4395.
   If you must enumerate:
   - never `pairs` an object; only `pairs` plain Lua tables you built yourself.
2. **`getmetatable()` probing of `hl.*` objects generally** — including
   `__index`, `__tostring`, `__newindex` field hunts.
3. **`print(...)` inside `hyprctl repl`** (its exit path is implicated in the
   crash); use `return value` instead.
4. **Unknown/undocumented dispatcher calls on the live session**
   (calling `hl.dsp.*` functions with guessed signatures, e.g. testing whether
   `hl.dsp.window.set_prop({...})` accepts some shape at runtime). Find
   signatures in matching version documentation/source, not by live probing.
5. Never guess or trial-and-error `hyprctl` arguments. Verify syntax against
   installed-version documentation offline; do not infer CLI syntax from the
   Lua API or test uncertain syntax against the live compositor.

## Known gotchas

- The executable and shell resolution for `hyprctl` can vary by environment.
  Inspect them offline rather than assuming a wrapper or a particular CLI
  implementation; any invocation still requires the explicit permission
  above.
- Window objects expose `address`, `pid`, `class`, `title`, `floating`,
  `fullscreen` — **not** `opacity` (nil, and `getprop` via hyprctl is how to
  read opacity). Treat this as a recorded host-specific observation, not a
  guarantee for other versions.
- binds listed by `hyprctl binds -j` may be incomplete / misrepresent Lua
  binds (observed here as a subset with `dispatcher: __lua` and chunk-id
  arguments). Don't conclude "bind missing" from that output alone.
- Crash reports land in `~/.cache/hyprland/hyprlandCrashReport*.txt`
  (newest mtime = freshest). Signal 6 + `__throw_bad_any_cast()` ⇒ Lua-bridge
  crash. Post-mortem reading is fine, do not repro-bang on the live session.

## If it crashes anyway

Stop immediately, do not run anything further Hyprland-related, apologize with
accountability (own the command that did it), and wait for the user to reboot
and confirm. Read the newest crash report only after they've restarted, and
fold the cause into this skill.
