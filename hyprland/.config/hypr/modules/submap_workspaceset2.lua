local N = 2
local key = "2"
local offset = N * 10

-- hl.bind("SUPER CTRL, " .. key, 'exec hyprctl dispatch submap workspaceset' .. N .. ' && notify-send -e -i ~/Pictures/icons/hyprland.icon "Hyprland" "Using the ' .. N .. 'nd set of extra workspaces"')
	hl.bind("SUPER+CTRL+ " .. key, function()
		hl.dispatch(hl.dsp.submap("workspaceset" .. N))
		hl.dsp.exec_cmd("notify-send -e -i ~/Pictures/icons/hyprland.icon 'Hyprland' 'Using the " .. N .. "nd set of extra workspaces'")
	end)

hl.define_submap("workspaceset" .. N, function()
    package.loaded["modules.common_bindings"] = nil
	require("modules.common_bindings")

	for i = 1, 9 do
		hl.bind("SUPER+ " .. i, hl.dsp.focus({ workspace = "" .. (offset + i) }))
		hl.bind("SUPER+SHIFT+ " .. i, hl.dsp.window.move({ workspace = "" .. (offset + i) }))
	end
	hl.bind("SUPER+ 0", hl.dsp.focus({ workspace = "" .. (offset + 10) }))
	hl.bind("SUPER+SHIFT+ 0", hl.dsp.window.move({ workspace = "" .. (offset + 10) }))

	hl.bind("SUPER+ D", hl.dsp.workspace.toggle_special("magic" .. N))
	hl.bind("SUPER+SHIFT+ D", hl.dsp.window.move({ workspace = "special:magic" .. N}))
	hl.bind("SUPER+CTRL+ D", hl.dsp.workspace.toggle_special("source" .. N))
	hl.bind("SUPER+CTRL+SHIFT+ D", hl.dsp.window.move({ workspace = "special:source" .. N}))

	-- hl.bind("SUPER CTRL, " .. key, 'exec hyprctl dispatch submap reset && notify-send -e -i ~/Pictures/icons/hyprland.icon "Hyprland" "Using the normal set of workspaces"')
	hl.bind("SUPER+CTRL+ " .. key, function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dsp.exec_cmd("notify-send -e -i ~/Pictures/icons/hyprland.icon 'Hyprland' 'Using the normal set of workspaces'")
	end)
end)
