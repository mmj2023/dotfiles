---
name: myquickshell-bar-and-notes
description: Use when changing MyQuickshell's bar layering, Hyprland special-workspace/fullscreen behavior, Notes shortcut, Notes overlay focus, or Notes persistence.
---

# MyQuickshell bar and Notes behavior

Read this skill together with the MyQuickshell repository's `AGENTS.md` and
`.github/copilot-instructions.md`. Those files define QML architecture,
theming, spacing, and validation conventions.

## Bar and fullscreen workspaces

- Preserve normal fullscreen behavior: a fullscreen window on a regular
  workspace may cover the bar.
- The exception is monitor-local: when a special workspace is visible over a
  regular workspace that is actively showing a fullscreen window, the bar on
  that monitor must remain above the fullscreen content so the special
  workspace can be used.
- Require both conditions together (visible special workspace and fullscreen
  regular workspace). Do not promote the bar for every fullscreen window, and
  restore its normal layer as soon as the special workspace is hidden.
- Hide the bar if a window on the visible special workspace itself is
  fullscreen.
- Keep state updates responsive to workspace transitions without relying on
  stale monitor data. Review all affected layer/visibility states, not only
  the special-workspace case.
- Never test against the live compositor without explicit user permission for
  that specific action. Follow the mandatory
  `hyprland-live-safety` skill before any Hyprland-related operation.

## Notes

- Super+Shift+N opens MyQuickshell Notes rather than DMS's notepad.
- The Notes overlay must receive keyboard focus reliably when opened from its
  keybinding or IPC entry point.
- Preserve the open-note/session state and editor options across restarts.
- Do not let opening or closing Notes cause the bar to remain above ordinary
  fullscreen content.

## Implementation expectations

- Keep UI declarative and compositor/system integration behind existing
  services.
- Prefer the existing per-screen `PanelWindow` and bar patterns.
- Use theme tokens and the repository's popup/spacing rules; avoid unrelated
  UI or configuration changes.
- Validate the changed QML and report any live-session behavior that could not
  be tested safely.
