# Personal agent guidance

This directory is the versioned source of truth for personal agent guidance
and user-authored skills. Changes are visible in the dotfiles Git worktree.
Built-in and vendor-managed skills are intentionally not copied or modified.

## Canonical guidance

- [`AGENTS.md`](AGENTS.md) — cross-agent preferences, including strict
  Hyprland live-session safety and the MyQuickshell behavior contract.
- [`skills/hyprland-live-safety/SKILL.md`](skills/hyprland-live-safety/SKILL.md)
  — the full mandatory safety rules for Hyprland work.
- [`skills/myquickshell-bar-and-notes/SKILL.md`](skills/myquickshell-bar-and-notes/SKILL.md)
  — the expected bar, special-workspace, and Notes behavior.

## Agent entry points

- `~/.claude/CLAUDE.md` and `~/.gemini/GEMINI.md` link to `AGENTS.md`.
- `~/.config/opencode/skills/` contains links to the user-authored skills
  above.
- MyQuickshell's root `AGENTS.md` and `.github/copilot-instructions.md`
  direct repository agents to these preferences; project-specific conventions
  remain in the repository.

To confirm the links on this machine, run:

```sh
~/dotfiles/agent-guidance/link-agent-guidance.sh
readlink -f ~/.claude/CLAUDE.md
readlink -f ~/.gemini/GEMINI.md
readlink -f ~/.config/opencode/skills/hyprland-live-safety
readlink -f ~/.config/opencode/skills/myquickshell-bar-and-notes
```

The link script is safe to rerun: it accepts already-correct links and refuses
to overwrite unrelated files or symlinks.
