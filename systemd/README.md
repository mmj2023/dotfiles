# systemd (user units)

User-level systemd units, stow-packaged. Link with:

```bash
cd ~/dotfiles && stow systemd
```

## searxng.service — SearXNG stack autostart

Starts the SearXNG podman-compose stack (core + valkey, defined in
`~/Projects/projects/searxng/docker-compose.yml`) for the graphical session,
so the local search engine on `http://127.0.0.1:6060` is always reachable
before the browser uses it as the default search engine.

```bash
systemctl --user enable --now searxng      # activate + autostart on login
systemctl --user status searxng            # check
systemctl --user restart searxng           # restart stack
systemctl --user disable --now searxng     # remove from autostart
```

### Notes

- `Type=oneshot` + `RemainAfterExit=yes`: unit just runs `podman-compose up -d
  --no-recreate` (ExecStart) and `stop` (ExecStop); it isn't a daemon itself.
- Bound to `graphical-session.target` — starts with any proper graphical
  session (KDE/GNOME natively; Hyprland via one exec-once in hyprland.lua that
  starts the target since dms-greeter launches Hyprland outside systemd).
  Does NOT run on TTY/SSH-only logins. Lingering is OFF.
- The stack's full deployment details (podman, podman-compose install,
  config quirks of the SearXNG image, ownership workaround on
  `./core-config/`) live in `~/Projects/projects/searxng/podman-setup.md`.
