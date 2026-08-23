-- Scratchpad keybindings
-- hl.bind("SUPER, D", "togglespecialworkspace magic")
-- hl.bind("SUPER SHIFT, D", "movetoworkspace special:magic")
-- hl.bind("SUPER CTRL, D", "togglespecialworkspace source")
-- hl.bind("SUPER CTRL SHIFT, D", "movetoworkspace special:source")
hl.bind("SUPER + D",         hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + D", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind("SUPER + CTRL + D",         hl.dsp.workspace.toggle_special("secret"))
hl.bind("SUPER + CTRL + SHIFT + D", hl.dsp.window.move({ workspace = "special:secret" }))
