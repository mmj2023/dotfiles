-- hl.bind("SUPER, G", 'exec hyprctl dispatch submap movetoworkspace && notify-send -e -i ~/Pictures/icons/hyprland.icon "Hyprland" "Started Move-to-Workspace mode"')
-- hl.bind("SUPER, G", hl.dsp.submap("movetoworkspace"), { description = "Move to workspace/convienience mode" })

hl.bind("SUPER+ G", function()
	-- hl.dispatch(hl.dsp.focus({ workspace = 2 }))
	-- hl.dsp.focus({ workspace = 2 })
	-- hl.dispatch(hl.dsp.exec_cmd(RqtBrw))
	hl.dispatch(hl.dsp.submap("movetoworkspace"))
    hl.dispatch(hl.dsp.exec_cmd([[notify-send -e -i ~/Pictures/icons/hyprland.icon 'Hyprland' 'Started Move-to-Workspace mode']]))
end)

hl.define_submap("movetoworkspace", function()
	for i = 1, 9 do
		-- hl.bind("SHIFT, " .. i, "movetoworkspace " .. i, { repeating = true })
		-- hl.bind(", " .. i, "workspace " .. i, { repeating = true })
		hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
		hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
	end
	-- hl.bind("SHIFT, 0", "movetoworkspace 10", { repeating = true })
	-- hl.bind(", 0", "workspace 10", { repeating = true })
	hl.bind("0", hl.dsp.focus({ workspace = "10" }))
	hl.bind("SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))

	-- hl.bind("D", "togglespecialworkspace magic", { repeating = true })
	-- hl.bind("SHIFT+ D", "movetoworkspace special:magic", { repeating = true })
	hl.bind("D", hl.dsp.workspace.toggle_special("magic"))
	hl.bind("SHIFT + D", hl.dsp.window.move({ workspace = "special:magic" }))
	hl.bind("SHIFT+ L", hl.dsp.exec_cmd("pidof dms && dms ipc call lock lock || hyprlock"))

	-- hl.bind(
	-- 	"escape",
	-- 	hl.dispatch(hl.dsp.exec_cmd()
	-- 		"hyprctl dispatch submap reset && notify-send -e -i ~/Pictures/icons/hyprland.icon 'Hyprland' 'Normal mode'"
	-- 	)
	-- )
	-- hl.bind(
	-- 	"SUPER, G",
	-- 	hl.dispatch(hl.dsp.exec_cmd()
	-- 		"hyprctl dispatch submap reset && notify-send -e -i ~/Pictures/icons/hyprland.icon 'Hyprland' 'Normal mode'"
	-- 	)
	-- )
	hl.bind("SUPER+ G", function()
		-- hl.dispatch(hl.dsp.focus({ workspace = 2 }))
		-- hl.dsp.focus({ workspace = 2 })
		-- hl.dispatch(hl.dsp.exec_cmd(RqtBrw))
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("notify-send -e -i ~/Pictures/icons/hyprland.icon 'Hyprland' 'Normal mode'"))
	end)
	hl.bind("escape", function()
		-- hl.dispatch(hl.dsp.focus({ workspace = 2 }))
		-- hl.dsp.focus({ workspace = 2 })
		-- hl.dispatch(hl.dsp.exec_cmd(RqtBrw))
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("notify-send -e -i ~/Pictures/icons/hyprland.icon 'Hyprland' 'Normal mode'"))
	end)
end)
