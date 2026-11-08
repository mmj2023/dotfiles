-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})
require("monitors")

-----------------------
--- Local variables ###
-----------------------
local mod = "SUPER"
local terminal = "prime-run ghostty"
local fileManager = "prime-run nemo"
local menu = "rofi -show run"
local colors = require("dms.matugen_colors")

-- Convert "#RRGGBB" to "rgb(RRGGBB)" for Hyprland
local function rgb(hex)
	return "rgb(" .. hex:sub(2) .. ")"
end

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

require("modules.environment")

----------------------------------
----- CONFIG & PERMISSIONS -------
----------------------------------

hl.config({
	input = {
		kb_layout = "us",
		repeat_delay = 150,
		repeat_rate = 50,
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:swapescape",
		kb_rules = "",

		follow_mouse = 2,
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
			middle_button_emulation = true,
			disable_while_typing = false,
		},
	},

	group = {
		col = {
			border_active = rgb(colors.primary) .. " " .. rgb(colors.outline) .. " 45deg",
			border_locked_active = rgb(colors.error) .. " " .. rgb(colors.outline) .. " 45deg",
			border_inactive = "rgba(4f4f4faa)",
		},
		groupbar = {
			font_size = 11,
			text_color = "rgba(AEE9D1aa)",
			font_weight_active = "bold",
			col = {
				active = rgb(colors.primary) .. " " .. rgb(colors.outline) .. " 90deg",
				locked_active = rgb(colors.error) .. " " .. rgb(colors.outline) .. " 90deg",
				inactive = "rgba(707070ff)",
				locked_inactive = "rgba(707070ff)",
			},
		},
	},

	general = {
		gaps_in = 2,
		gaps_out = 2,
		border_size = 2,
		col = {
			active_border = rgb(colors.primary) .. " " .. rgb(colors.outline) .. " 45deg",
			inactive_border = "rgba(707070ff)",
		},
		resize_on_border = true,
		extend_border_grab_area = 20,
		allow_tearing = false,
	},

	decoration = {
		rounding = 4,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = false,
			range = 30,
			render_power = 5,
			offset = "0 5",
			color = "rgba(00000070)",
		},
		blur = {
			enabled = false,
			size = 4,
			passes = 6,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
		bezier = {
			{ name = "easeOutQuint", x0 = 0.23, y0 = 1, x1 = 0.32, y1 = 1 },
			{ name = "easeInOutCubic", x0 = 0.65, y0 = 0.05, x1 = 0.36, y1 = 1 },
			{ name = "linear", x0 = 0, y0 = 0, x1 = 1, y1 = 1 },
			{ name = "almostLinear", x0 = 0.5, y0 = 0.5, x1 = 0.75, y1 = 1.0 },
			{ name = "quick", x0 = 0.15, y0 = 0, x1 = 0.1, y1 = 1 },
		},
		animation = {
			{ name = "windowsIn", enabled = 1, speed = 3, curve = "default" },
			{ name = "windowsOut", enabled = 1, speed = 3, curve = "default" },
			{ name = "windowsMove", enabled = 1, speed = 4, curve = "default" },
			{ name = "fade", enabled = 1, speed = 3, curve = "default" },
			{ name = "border", enabled = 1, speed = 3, curve = "default" },
			{ name = "workspaces", enabled = 1, speed = 0.97, curve = "almostLinear", style = "fade" },
			{ name = "workspacesIn", enabled = 1, speed = 0.605, curve = "almostLinear", style = "slidevert" },
			{ name = "workspacesOut", enabled = 1, speed = 0.97, curve = "almostLinear", style = "slidevert" },
		},
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	xwayland = {
		force_zero_scaling = true,
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		focus_on_activate = true,
		disable_splash_rendering = true,
		vrr = 1,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		enable_swallow = false,
		swallow_regex = "(foot|kitty|allacritty|Alacritty|ghostty)",
		on_focus_under_fullscreen = 1,
		exit_window_retains_fullscreen = false,
		allow_session_lock_restore = 1,
		background_color = "rgba(0,0,0,0)",
		session_lock_xray = true,
		initial_workspace_tracking = 2,
	},

	cursor = {
		no_hardware_cursors = 1,
		zoom_factor = 1,
		zoom_rigid = true,
		inactive_timeout = 0.3,
		hide_on_key_press = true,
		no_warps = true,
		zoom_disable_aa = false,
	},

	binds = {
		scroll_event_delay = 0,
	},

	debug = {
		vfr = true,
	},
})

hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd("hyprctl setcursor cz-Hickson-black 24")
	hl.exec_cmd("xrdb ~/.Xresources")
	hl.exec_cmd("bash -c 'wl-paste --watch cliphist store &'")
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("dms run")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("elephant")
	hl.exec_cmd("copyq --start-server")
	hl.exec_cmd("flameshot")
	hl.exec_cmd("walker --gapplication-service")
	hl.exec_cmd("wayscriber --daemon")
	hl.exec_cmd("kwalletd6")
	hl.exec_cmd("prime-run ghostty", { workspace = "1 silent" })
	hl.exec_cmd("prime-run kitty", { workspace = "special:magic silent" })
	hl.exec_cmd("prime-run zen", { workspace = "2 silent" })
	hl.exec_cmd("prime-run helium-browser --ozone-platform=wayland --use-gl=egl", { workspace = "5 silent" })
	hl.exec_cmd("prime-run librewolf", { workspace = "6 silent" })
end)

----------------------
---- WINDOW RULES ----
----------------------

hl.workspace({ rules = { "gapsout:0", "gapsin:0" }, selector = "w[tv1]" })
hl.workspace({ rules = { "gapsout:0", "gapsin:0" }, selector = "f[1]" })

hl.windowrule({ border_size = 0, match = { float = false, workspace = "w[tv1]" } })
hl.windowrule({ rounding = 0, match = { float = false, workspace = "w[tv1]" } })
hl.windowrule({ border_size = 0, match = { float = false, workspace = "f[1]" } })
hl.windowrule({ rounding = 0, match = { float = false, workspace = "f[1]" } })

hl.windowrule({ tile = true, match = { class = "^(org\\.wezfurlong\\.wezterm)$" } })
hl.windowrule({ rounding = 12, match = { class = "^(org\\.gnome\\.)" } })
hl.windowrule({ border_size = 0, match = { class = "^(org\\.gnome\\.)" } })

hl.windowrule({ tile = true, match = { class = "^(gnome-control-center)$" } })
hl.windowrule({ tile = true, match = { class = "^(pavucontrol)$" } })
hl.windowrule({ tile = true, match = { class = "^(nm-connection-editor)$" } })

hl.windowrule({ float = true, match = { class = "^(gnome-calculator)$" } })
hl.windowrule({ float = true, match = { class = "^(galculator)$" } })
hl.windowrule({ float = true, match = { class = "^(blueman-manager)$" } })
hl.windowrule({ float = true, match = { class = "^(xdg-desktop-portal)$" } })

hl.windowrule({ border_size = 0, match = { class = "^(org\\.wezfurlong\\.wezterm)$", float = false } })
hl.windowrule({ border_size = 0, match = { class = "^(Alacritty)$", float = false } })
hl.windowrule({ border_size = 0, match = { class = "^(com\\.mitchellh\\.ghostty)$", float = false } })
hl.windowrule({ border_size = 0, match = { class = "^(kitty)$", float = false } })

hl.windowrule({ float = true, match = { class = "^(app\\.zen_browser\\.zen)$", title = "^(Picture-in-Picture)$" } })
hl.windowrule({ float = true, match = { class = "^(librewolf)$", title = "^(Picture-in-Picture)$" } })
hl.windowrule({ float = true, match = { class = "^(helium)$", title = "^(Picture-in-Picture)$" } })
hl.windowrule({ float = true, match = { class = "^(zoom)$" } })

hl.windowrule({
	name = "flameshot",
	no_anim = true,
	pin = true,
	float = true,
	stayfocused = true,
	suppress_event = "fullscreen",
	move = "0 0",
	content = "photo",
	match = {
		class = "^(flameshot)$",
	},
})


hl.windowrule({ opacity = "0.6 override", match = { tag = "transparent" } })

hl.windowrule({ float = true, match = { class = "^(com\\.github\\.hluk\\.copyq)$" } })
hl.windowrule({ size = "400 375", match = { class = "^(com\\.github\\.hluk\\.copyq)$" } })
hl.windowrule({ move = "(cursor_x-(window_w*0)) (cursor_y-(window_h*0))", match = { class = "^(com\\.github\\.hluk\\.copyq)$" } })

hl.windowrule({ float = true, match = { class = "^(io\\.github\\.Qalculate\\.qalculate-qt)$" } })
hl.windowrule({ size = "500 500", match = { class = "^(io\\.github\\.Qalculate\\.qalculate-qt)$" } })

hl.windowrule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.layerrule({ no_anim = true, match = { namespace = "^(quickshell)$" } })
hl.layerrule({ no_anim = true, match = { namespace = "^(desktop)$" } })

hl.device({
	name = "epic-mouse-v1",
	sensitivity = 0.5,
})

--------------------
---- KEYBINDINGS ---
--------------------

-- Window Management
hl.bind("SUPER, Q", "killactive")
hl.bind("SUPER, F", "fullscreen 0")
hl.bind("SUPER SHIFT, F", "fullscreenstate 1 0")
hl.bind("SUPER SHIFT, T", "togglefloating")
hl.bind("SUPER CTRL, W", "togglegroup")
hl.bind("SUPER, U", "lockactivegroup toggle")
hl.bind("SUPER, W", "changegroupactive")
hl.bind("SUPER SHIFT, W", "changegroupactive b")
hl.bind("ALT, Tab", "cyclenext")
hl.bind("ALT SHIFT, Tab", "cyclenext prev")

-- Utility Scripts & Tools
hl.bind("SUPER SHIFT, Y", 'exec grim -g "$(slurp)" /tmp/ocr.png && tesseract /tmp/ocr.png stdout | wl-copy && notify-send -i ~/Pictures/icons/hyprland.icon "Text copied to clipboard"')
hl.bind("SUPER, O", "tagwindow transparent")
hl.bind("SUPER, B", "exec ~/toggle_blur.sh")
hl.bind("SUPER CTRL, C", "exec hyprctl kill")
hl.bind("SUPER SHIFT, C", "exec pkill hyprpicker || hyprpicker | wl-copy")

-- Focus Navigation
hl.bind("SUPER, left", "movefocus l")
hl.bind("SUPER, down", "movefocus d")
hl.bind("SUPER, up", "movefocus u")
hl.bind("SUPER, right", "movefocus r")
hl.bind("SUPER, H", "movefocus l")
hl.bind("SUPER, J", "movefocus d")
hl.bind("SUPER, K", "movefocus u")
hl.bind("SUPER, L", "movefocus r")

-- Window Movement
hl.bind("SUPER SHIFT, left", "movewindow l")
hl.bind("SUPER SHIFT, down", "movewindow d")
hl.bind("SUPER SHIFT, up", "movewindow u")
hl.bind("SUPER SHIFT, right", "movewindow r")
hl.bind("SUPER SHIFT, H", "movewindow l")
hl.bind("SUPER SHIFT, J", "movewindow d")
hl.bind("SUPER SHIFT, K", "movewindow u")
hl.bind("SUPER SHIFT, L", "movewindow r")

-- Monitor Navigation & Movement
hl.bind("SUPER CTRL, left", "focusmonitor l")
hl.bind("SUPER CTRL, right", "focusmonitor r")
hl.bind("SUPER CTRL, H", "focusmonitor l")
hl.bind("SUPER CTRL, J", "focusmonitor d")
hl.bind("SUPER CTRL, K", "focusmonitor u")
hl.bind("SUPER CTRL, L", "focusmonitor r")
hl.bind("SUPER SHIFT CTRL, left", "movewindow mon:l")
hl.bind("SUPER SHIFT CTRL, down", "movewindow mon:d")
hl.bind("SUPER SHIFT CTRL, up", "movewindow mon:u")
hl.bind("SUPER SHIFT CTRL, right", "movewindow mon:r")
hl.bind("SUPER SHIFT CTRL, H", "movewindow mon:l")
hl.bind("SUPER SHIFT CTRL, J", "movewindow mon:d")
hl.bind("SUPER SHIFT CTRL, K", "movewindow mon:u")
hl.bind("SUPER SHIFT CTRL, L", "movewindow mon:r")

-- Screenshots & Recording
hl.bind(", XF86Launch1", "exec grimblast copy area")
hl.bind("CTRL, XF86Launch1", "exec grimblast copy screen")
hl.bind("ALT, XF86Launch1", "exec grimblast copy active")
hl.bind(", Print", "exec grimblast copy area")
hl.bind("CTRL, Print", "exec grimblast copy screen")
hl.bind("ALT, Print", "exec grimblast copy active")
hl.bind("SUPER SHIFT, S", "exec flameshot gui")
hl.bind("SUPER, X", "exec pkill -SIGUSR1 wayscriber")
hl.bind("SUPER SHIFT, X", "exec wayscriber --active")

-- System Controls & Security
hl.bind("SUPER SHIFT, P", "dpms off")
hl.bind("SUPER CTRL, P", "exec systemctl suspend || loginctl suspend")
hl.bind("SUPER CTRL SHIFT, P", "exec wlogout")
hl.bind("SUPER ALT, L", "exec hyprlock")
hl.bind("SUPER SHIFT, E", "exit")
hl.bind("CTRL ALT, Delete", "exec dms ipc call processlist toggle")

-- Layout & Resizing
hl.bind("SUPER, bracketleft", "layoutmsg preselect l")
hl.bind("SUPER, bracketright", "layoutmsg preselect r")
hl.bind("SUPER, R", "layoutmsg togglesplit")
hl.bind("SUPER CTRL, F", "resizeactive exact 100%")
hl.bind("SUPER, code:20", "resizeactive -100 0", { desc = "Expand window left" })
hl.bind("SUPER, code:21", "resizeactive 100 0", { desc = "Shrink window left" })

-- Mouse Dragging
hl.bind("SUPER, mouse:272", "movewindow", { click = true, drag = true, desc = "Move window" })
hl.bind("SUPER, mouse:273", "resizewindow", { click = true, drag = true, desc = "Resize window" })

-- Zoom Controls
hl.bind("SUPER, minus", 'exec hyprctl getoption cursor:zoom_factor | grep float | awk \'{if($2!=1) system("hyprctl keyword cursor:zoom_factor " $2 - 0.1) }\'', { repeating = true })
hl.bind("SUPER, equal", 'exec hyprctl getoption cursor:zoom_factor | grep float | awk \'{ system("hyprctl keyword cursor:zoom_factor " $2 + 0.1) }\'', { repeating = true })
hl.bind("SUPER SHIFT, equal", "exec hyprctl keyword cursor:zoom_factor 1.0", { repeating = true })
hl.bind("SUPER, mouse_up", "exec hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')")
hl.bind("SUPER, mouse_down", "exec hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')")

-- Application Launchers
hl.bind("SUPER, T", "exec " .. terminal)
hl.bind("SUPER SHIFT, space", "exec dms ipc call spotlight toggle")
hl.bind("SUPER ALT SHIFT, space", "exec " .. menu)
hl.bind("SUPER, space", "exec nc -U /run/user/1000/walker/walker.sock")
hl.bind("SUPER ALT, space", "exec krunner")
hl.bind(", F12", "pass class:^(com\\.obsproject\\.Studio)$")
hl.bind("SUPER, V", "exec copyq toggle")
hl.bind("SUPER SHIFT, V", "exec dms ipc call clipboard toggle")
hl.bind("SUPER, E", "exec " .. fileManager)
hl.bind("SUPER, M", "exec dms ipc call processlist toggle")
hl.bind("SUPER, comma", "exec dms ipc call settings toggle")
hl.bind("SUPER, N", "exec dms ipc call notifications toggle")
hl.bind("SUPER SHIFT, N", "exec dms ipc call notepad toggle")
hl.bind("SUPER CTRL, V", "exec voxtype record start")
hl.bind("SUPER CTRL, V", "exec voxtype record stop", { release = true })

-- Workspace & Column Navigation
hl.bind("SUPER, Home", "focuswindow first")
hl.bind("SUPER, End", "focuswindow last")
hl.bind("SUPER, S", "workspace m+1")
hl.bind("SUPER, A", "workspace m-1")
hl.bind("SUPER, Tab", "workspace previous")
hl.bind("SUPER ALT, O", "exec hyprctl dispatch overview:toggle")
hl.bind("SUPER, Page_Down", "workspace e+1")
hl.bind("SUPER, Page_Up", "workspace e-1")
hl.bind("SUPER, KP_Prior", "workspace e+1")
hl.bind("SUPER, KP_Next", "workspace e-1")
hl.bind("SUPER CTRL, down", "movetoworkspace e+1")
hl.bind("SUPER CTRL, up", "movetoworkspace e-1")
hl.bind("SUPER CTRL, U", "movetoworkspace e+1")
hl.bind("SUPER CTRL, I", "movetoworkspace e-1")

-- Move Workspaces
hl.bind("SUPER SHIFT, Page_Down", "movetoworkspace e+1")
hl.bind("SUPER SHIFT, Page_Up", "movetoworkspace e-1")
hl.bind("SUPER SHIFT, U", "movetoworkspace e+1")
hl.bind("SUPER SHIFT, I", "movetoworkspace e-1")

-- Mouse Wheel Navigation
hl.bind("SUPER ALT, mouse_down", "workspace e+1")
hl.bind("SUPER ALT, mouse_up", "workspace e-1")
hl.bind("SUPER CTRL, mouse_down", "movetoworkspace e+1")
hl.bind("SUPER CTRL, mouse_up", "movetoworkspace e-1")
hl.bind("SUPER CTRL, M", "layoutmsg scrolling")

-- Audio & Hardware Keys
hl.bind(", XF86AudioRaiseVolume", "exec dms ipc call audio increment 3", { repeating = true, locked = true })
hl.bind(", XF86AudioLowerVolume", "exec dms ipc call audio decrement 3", { repeating = true, locked = true })
hl.bind(", XF86AudioMute", "exec dms ipc call audio mute", { locked = true })
hl.bind(", XF86AudioMicMute", "exec dms ipc call audio micmute", { locked = true })
hl.bind(", XF86KbdBrightnessUp", "exec kbdbrite.sh up", { repeating = true, locked = true })
hl.bind(", XF86KbdBrightnessDown", "exec kbdbrite.sh down", { repeating = true, locked = true })
hl.bind(", XF86MonBrightnessUp", "exec dms ipc call brightness increment 5", { repeating = true, locked = true })
hl.bind(", XF86MonBrightnessDown", "exec dms ipc call brightness decrement 5", { repeating = true, locked = true })
hl.bind(", XF86AudioNext", "exec playerctl next", { locked = true })
hl.bind(", XF86AudioPause", "exec playerctl play-pause", { locked = true })
hl.bind(", XF86AudioPlay", "exec playerctl play-pause", { locked = true })
hl.bind(", XF86AudioPrev", "exec playerctl previous", { locked = true })
hl.bind(", XF86Calculator", "exec qalculate-qt", { locked = true })

-- Lid Switch
hl.bind(", switch:off:Lid Switch", "exec systemctl suspend", { locked = true })
hl.bind(", switch:on:Lid Switch", "exec hyprctl dispatch dpms on", { locked = true })

-- Workspaces 1..10
for i = 1, 9 do
	hl.bind("SUPER, " .. i, "workspace " .. i)
	hl.bind("SUPER SHIFT, " .. i, "movetoworkspace " .. i)
end
hl.bind("SUPER, 0", "workspace 10")
hl.bind("SUPER SHIFT, 0", "movetoworkspace 10")

-- Scratchpad Workspaces
hl.bind("SUPER, D", "togglespecialworkspace magic")
hl.bind("SUPER SHIFT, D", "movetoworkspace special:magic")
hl.bind("SUPER CTRL, D", "togglespecialworkspace source")
hl.bind("SUPER CTRL SHIFT, D", "movetoworkspace special:source")

-- Submap triggers
hl.bind("SUPER, G", 'exec hyprctl dispatch submap movetoworkspace && notify-send -e -i ~/Pictures/icons/hyprland.icon "Hyprland" "Started Move-to-Workspace mode"')
hl.bind("SUPER CTRL, R", 'exec hyprctl dispatch submap resize && notify-send -e -i ~/Pictures/icons/hyprland.icon "Hyprland" "Started Resize mode"')
for i = 1, 10 do
	hl.bind("SUPER CTRL, " .. (i % 10), 'exec hyprctl dispatch submap workspaceset' .. i .. ' && notify-send -e -i ~/Pictures/icons/hyprland.icon "Hyprland" "Using set ' .. i .. ' of extra workspaces"')
end

