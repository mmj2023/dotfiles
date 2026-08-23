require("modules.common_bindings")
require("modules.scratchpad")

-- === Numbered Workspaces ===
for i = 1, 9 do
	-- hl.bind("SUPER, " .. i, "workspace " .. i)
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = "" .. i }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = "" .. i }))
	-- hl.bind("SUPER SHIFT, " .. i, "movetoworkspace " .. i)
end
-- hl.bind("SUPER, 0", "workspace 10")
-- hl.bind("SUPER SHIFT, 0", "movetoworkspace 10")
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))
