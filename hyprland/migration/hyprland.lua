-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")
------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
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

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- hl.env("XCURSOR_SIZE", "24")
require("modules.environment")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

hl.config({
	-- ecosystem = {
	--   enforce_permissions = true,
	-- },
	input = {
		kb_layout = "us",
		-- # numlock_by_default = true
		repeat_delay = 150,
		repeat_rate = 50,
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:swapescape",
		kb_rules = "",

		follow_mouse = 2,
		-- # emulate_discrete_scroll = 1
		-- # mouse_refocus = 0
		-- # off_window_axis_events = 2

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			-- # disable_while_typing = true
			natural_scroll = true,
			-- # clickfinger_behavior = true
			middle_button_emulation = true,
			disable_while_typing = false,
			-- # scroll_factor = 0.5
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

	scrolling = {
		fullscreen_on_one_column = true,
		focus_fit_method = 0,
		follow_focus = true,
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

require("modules.gestures")

-- === Application Launchers ===
require("modules.keybinds")

-- === Move to Workspacesets ===
require("modules.submaps")

-- === Lid switch ===
hl.bind(", switch:off:Lid Switch", "exec systemctl suspend", { locked = true })
hl.bind(", switch:on:Lid Switch", "exec hyprctl dispatch dpms on", { locked = true })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	-- hl.exec_cmd(terminal)
	-- hl.exec_cmd("nm-applet")
	-- hl.exec_cmd("waybar & hyprpaper & firefox")
	-- # exec-once = hyprpaper &
	-- # exec-once = killall dunst && dunst &
	-- # exec-once = lxqt-policykit-agent &
	-- # exec-once = wl-paste --type text --watch cliphist store
	-- # exec-once = wl-paste --type image --watch cliphist store
	-- # exec-once = waybar & hyprpaper & firefox
	-- # exec-once = nm-applet &
	-- # exec-once = blueman-applet &
	-- # exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
	-- # exec-once = dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS
	-- # exec-once = /usr/lib/mate-polkit/polkit-mate-authentication-agent-1
	-- # exec-once = bash ~/protal.sh
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd("hyprctl setcursor cz-Hickson-black 24")
	hl.exec_cmd("xrdb ~/.Xresources")
	-- # exec-once = hyprctl setcursor breeze_cursors 24
	-- # exec-once = killall hypridle & hypridle
	hl.exec_cmd("bash -c 'wl-paste --watch cliphist store &'")
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("dms run")
	-- # # exec-once = systemctl --user start hyprpolkitagent
	hl.exec_cmd("hyprsunset")
	-- # # exec-once = snixembed
	hl.exec_cmd("elephant")
	hl.exec_cmd("copyq --start-server")
	hl.exec_cmd("flameshot")
	hl.exec_cmd("walker --gapplication-service")
	hl.exec_cmd("wayscriber --daemon")
	hl.exec_cmd("kwalletd6")
	hl.exec_cmd("prime-run ghostty", { workspace = "1 silent" })
	hl.exec_cmd("prime-run kitty", { workspace = "special:magic silent" })
	hl.exec_cmd("prime-run zen", { workspace = "2 silent" })
	-- # exec-once = [workspace 5 silent] ~/AppImages/squashfs-root/AppRun

	-- # exec-once = [workspace 5 silent] sleep 1 && prime-run helium-browser --ozone-platform=x11
	hl.exec_cmd("prime-run helium-browser --ozone-platform=wayland --use-gl=egl", { workspace = "5 silent" })
	hl.exec_cmd("prime-run librewolf", { workspace = "6 silent" })
	-- # for dolphin
	-- # disabled cause the tray gets broken
	-- # exec-once = XDG_MENU_PREFIX=plasma- kbuildsycoca6 --noincremental
	-- # exec-once = kded6 &
end)

----------------------
---- WINDOW RULES ----
----------------------

hl.workspace({ rules = { "gapsout:0", "gapsin:0" }, selector = "w[tv1]" })
hl.workspace({ rules = { "gapsout:0", "gapsin:0" }, selector = "f[1]" })
hl.workspace({ rules = { "layout:scrolling" }, selector = "2" })
hl.workspace({ rules = { "layout:scrolling" }, selector = "5" })

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
	pin = false,
	float = true,
	fullscreen_state = "2 0",
	move = "0 0",
	content = "photo",
	match = {
		class = "flameshot",
		title = "flameshot",
	},
})

-- windowrule for transparent tag removed - tagwindow broken in 0.56, using setprop instead

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

-------------------
---- PLUGINS ------
-------------------

hl.plugin("dynamic-cursors", {
	enabled = false,
	mode = "none",
	threshold = 2,
	rotate = {
		length = 20,
		offset = 0.0,
	},
	tilt = {
		limit = 5000,
		-- function = "negative_quadratic",
		window = 100,
	},
	stretch = {
		limit = 3000,
		function = "quadratic",
		window = 100,
	},
	shake = {
		enabled = true,
		nearest = true,
		threshold = 5.785,
		base = 3.0,
		speed = 1.0,
		influence = 0.0,
		limit = 0.0,
		timeout = 2000,
		effects = false,
		ipc = false,
	},
	hyprcursor = {
		nearest = true,
		enabled = true,
		resolution = -1,
		fallback = "clientside",
	},
})

hl.plugin("overview", {
	overrideGaps = false,
	gapsIn = 10,
	gapsOut = 30,
	panelHeight = 300,
	reservedArea = 32,
	workspaceActiveBorder = "rgba(99999999)",
	workspaceInactiveBorder = "rgba(55555599)",
	drawActiveWorkspace = false,
	showOvelayLayers = true,
	hideRealLayers = true,
	affectStrut = false,
	panelBorderWidth = 0,
	panelBorderColor = "rgba(707070cc)",
	panelColor = "rgba(10101044)",
})
