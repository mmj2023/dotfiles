local wezterm = require("wezterm")
local config = wezterm.config_builder()
-- -- local native_settings = require('~/.config/wezterm/native_settings.lua')
-- -- wezterm.add_to_config_reload_watch_list('~/.config/wezterm/native_settings.lua')
-- -- Merge settings from additional files
-- -- for k, v in pairs(settings) do config[k] = v end
config.automatically_reload_config = true
config.adjust_window_size_when_changing_font_size = false
config.hide_mouse_cursor_when_typing = true
--
config.visual_bell = {
	fade_in_duration_ms = 150,
	fade_out_duration_ms = 150,
	target = "BackgroundColor",
}
config.enable_wayland = true
config.audible_bell = "Disabled"
config.window_close_confirmation = "NeverPrompt"
-- config.term = "xterm-kitty"
-- config.term = "xterm-kitty"
--
-- -- Set primary rendering frontend
-- -- local function get_frontend()
-- --   local preferred_frontend = "WebGpu"  -- Try WebGPU first
-- --
-- --   if wezterm.gui then
-- --     local backend = wezterm.gui.front_end
-- --     if backend == "WebGpu" then
-- --       return "WebGpu"
-- --     elseif backend == "OpenGL" then
-- --       return "OpenGL"
-- --     end
-- --   end
-- --
-- --   -- Fallback to OpenGL if WebGPU is unavailable
-- --   return "OpenGL"
-- -- end
-- -- Read a preferred frontend from an environment variable, defaulting to WebGpu.
-- local env_frontend = os.getenv("WEZTERM_PREFERRED_FRONTEND")
-- local preferred_frontend
--
-- if env_frontend then
--   preferred_frontend = env_frontend
-- else
--   -- For example, if you're on Windows, you might prefer WebGpu.
--   if wezterm.target_triple:find("windows") then
--     preferred_frontend = "WebGpu"
--   else
--     -- Or on Linux/macOS, you might decide OpenGL works better.
--     preferred_frontend = "OpenGL"
--   end
-- end
--
-- config.prefer_egl = true
-- config.front_end = preferred_frontend
config.front_end = "OpenGL"
config.webgpu_power_preference = "HighPerformance"
-- config.opengl_power_preference = "HighPerformance"
-- config.front_end = "Software"
-- config.front_end = "Vulkan"
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" })
config.font_size = 12.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
--
-- config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.scrollback_lines = 10000
config.window_background_opacity = 0.3
-- wezterm.on("toggle-opacity", function(window, pane)
-- 	-- print("toggle-blur")
-- 	local overrides = window:get_config_overrides() or {}
-- 	overrides.win32_system_backdrop = "Acrylic"
-- 	overrides.window_decorations = "RESIZE"
-- 	if overrides.window_background_opacity == 0.5 then
-- 	-- if not overrides.win32_system_backdrop then
-- 	else
-- 		overrides.win32_system_backdrop = "Disable"
-- 		overrides.window_decorations = "RESIZE"
-- 	end
-- 	window:set_config_overrides(overrides)
-- end)
-- config.keys = {
-- 	{ key = "F11", action = wezterm.action.ToggleFullScreen },
-- 	{
-- 		mods = "CTRL|ALT",
-- 		key = "b",
-- 		action = wezterm.action.EmitEvent("toggle-opacity"),
-- 	},
-- }
-- wezterm.on("toggle-opacity", function(window, pane)
-- 	local overrides = window:get_config_overrides() or {}
-- 	if not overrides.window_background_opacity then
-- 		overrides.window_background_opacity = 0.5
-- 	else
-- 		overrides.window_background_opacity = nil
-- 	end
-- 	window:set_config_overrides(overrides)
-- end)
-- wezterm.on("toggle-opacity", function(window, pane)
-- 	-- print("toggle-blur")
-- 	-- {
-- 	local overrides = window:get_config_overrides() or {}
-- 	overrides.win32_system_backdrop = "Acrylic"
-- 	overrides.window_decorations = "RESIZE"
-- 	if overrides.window_background_opacity == 0.5 then
-- 	-- if not overrides.win32_system_backdrop then
-- 	else
-- 		overrides.win32_system_backdrop = "Disable"
-- 		overrides.window_decorations = "RESIZE"
-- 	end
-- 	window:set_config_overrides(overrides)
-- end)
config.keys = {
	-- {
	-- 	key = "b",
	-- 	mods = "CTRL|ALT",
	-- 	action = wezterm.action.EmitEvent("toggle-opacity"),
	-- },
	{ key = "F11", action = wezterm.action.ToggleFullScreen },
}
-- -- {key="LeftArrow", mods="CTRL|SHIFT|ALT", action=wezterm.action{AdjustPaneSize={"Left", 1}}},
-- -- {key="RightArrow", mods="CTRL|SHIFT|ALT", action=wezterm.action{AdjustPaneSize={"Right", 1}}},
-- -- {key="UpArrow", mods="CTRL|SHIFT|ALT", action=wezterm.action{AdjustPaneSize={"Up", 1}}},
-- -- {key="DownArrow", mods="CTRL|SHIFT|ALT", action=wezterm.action{AdjustPaneSize={"Down", 1}}},
-- -- {
-- -- 	key = "A",
-- -- 	mods = "CTRL",
-- -- 	action = wezterm.action_callback(toggle_acrylic),
-- -- },
-- -- }
config.colors = {
	-- cursor_bg = '#52ad70',  -- Background color of the cursor
	-- cursor_bg = "#3e757f", -- Background color of the cursor
	-- cursor_fg = "black", -- Text color when the cursor is over text
	cursor_border = "#486b61", -- Border color of the cursor
	visual_bell = "#392061",
	selection_bg = "#657b7d",
	tab_bar = {
		background = wezterm.color.parse("rgba(0, 0, 0, 0.1)"), -- 50% transparent black
		active_tab = {
			bg_color = "#1a1a1a", -- Dark gray for active tab
			fg_color = "#ffffff",
		},
		inactive_tab = {
			bg_color = "#262626", -- Slightly lighter gray for inactive tabs
			fg_color = "#cccccc",
		},
	},
}
-- -- wezterm.plugin
-- -- 	.require("https://github.com/yriveiro/wezterm-tabs")
-- -- 	.apply_to_config(config, { tabs = { tab_bar_at_bottom = true } })
--
config.hide_tab_bar_if_only_one_tab = true
config.default_cursor_style = "BlinkingBlock"
config.force_reverse_video_cursor = true -- This ensures the cursor color matches the text color
config.enable_kitty_graphics = true
config.max_fps = 200
-- -- print("Active rendering backend: " .. wezterm.gui.front_end)
-- -- local frontend = wezterm.gui and wezterm.gui.front_end or "Unknown"
-- -- print("Active rendering backend: " .. frontend)
-- -- wezterm.on("window-config-reloaded", function(window, pane)
-- --   local frontend = wezterm.gui and wezterm.gui.front_end or "Unknown"
-- --   window:toast_notification("WezTerm Info", "Active rendering backend: " .. frontend, nil, 5000)
-- -- end)
return config
-- -- local function toggle_acrylic()
-- -- 	acrylic_enabled = not acrylic_enabled
-- -- 	if acrylic_enabled then
-- -- 		wezterm.set_config_overrides({
-- -- 			win32_system_backdrop = "Disable",
-- -- 			-- window_background_opacity = 1.0,
-- -- 		})
-- -- 	else
-- -- 		wezterm.set_config_overrides({
-- -- 			win32_system_backdrop = "Acrylic",
-- -- 			-- window_background_opacity = acrylic_enabled and 0.8 or 1.0,
-- -- 		})
-- -- 	end
-- -- local function toggleBlur(window)
-- -- 	local config = window:effective_config()
-- -- 	-- if config.window_background_opacity == 1 then
-- -- 	if config.win32_system_backdrop == "Acrylic" then
-- -- 		window:set_config_overrides({ window_background_opacity = 0.5 })
-- -- 		window:set_config_overrides({ win32_system_backdrop = "Disable" })
-- -- 	else
-- -- 		-- window:set_config_overrides({ window_background_opacity = 1 })
-- -- 		window:set_config_overrides({
-- -- 			win32_system_backdrop = "Acrylic", --[[ window_background_opacity = 0.8 ]]
-- -- 		})
-- -- 	end
-- -- end
-- -- wezterm.on("toggle-blur", toggleBlur)
-- -- config.win32_system_backdrop = "Disable"
-- -- return {
-- -- 	-- automatically_reload_config = true,
-- -- 	-- adjust_window_size_when_changing_font_size = false,
-- -- 	-- visual_bell = {
-- -- 	-- 	fade_in_duration_ms = 150,
-- -- 	-- 	fade_out_duration_ms = 150,
-- -- 	-- 	target = "BackgroundColor",
-- -- 	-- },
-- -- 	-- audible_bell = "Disabled",
-- -- 	-- window_close_confirmation = "NeverPrompt",
-- -- 	-- -- term = "xterm-kitty",
-- -- 	-- term = "wezterm",
-- -- 	-- prefer_egl = true,
-- -- 	-- front_end = "OpenGL",
-- -- 	-- default_prog = { "wsl.exe", "--distribution", "kali-linux" },
-- -- 	-- font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
-- -- 	-- font_size = 12.0,
-- -- 	-- harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
-- -- 	-- color_scheme = "Gruvbox Dark",
-- -- 	-- window_background_opacity = 0.5,
-- -- 	-- win32_system_backdrop = 'Acrylic',
-- -- 	-- window_decorations = "NONE",
-- -- 	-- window_decorations = "RESIZE",
-- -- 	-- enable_tab_bar = true,
-- -- 	-- hide_tab_bar_if_only_one_tab = true,
-- -- 	-- default_cwd = "/home/mylordtome", -- Ensure this matches your WSL home directory
-- -- 	-- scrollback_lines = 10000,
-- -- 	-- wsl_domains = {
-- -- 	-- 	{
-- -- 	-- 		name = "WSL:kali-linux",
-- -- 	-- 		distribution = "kali-linux",
-- -- 	-- 		default_cwd = "/home/mylordtome", -- Ensure this matches your WSL home directory
-- -- 	-- 	},
-- -- 	-- },
-- -- 	-- default_domain = "WSL:kali-linux",
-- -- 	-- keys = {
-- -- 	-- 	{ key = "F11", action = wezterm.action.ToggleFullScreen },
-- -- 	-- 	-- {key="LeftArrow", mods="CTRL|SHIFT|ALT", action=wezterm.action{AdjustPaneSize={"Left", 1}}},
-- -- 	-- 	-- {key="RightArrow", mods="CTRL|SHIFT|ALT", action=wezterm.action{AdjustPaneSize={"Right", 1}}},
-- -- 	-- 	-- {key="UpArrow", mods="CTRL|SHIFT|ALT", action=wezterm.action{AdjustPaneSize={"Up", 1}}},
-- -- 	-- 	-- {key="DownArrow", mods="CTRL|SHIFT|ALT", action=wezterm.action{AdjustPaneSize={"Down", 1}}},
-- -- 	-- 	-- {
-- -- 	-- 	-- 	key = "A",
-- -- 	-- 	-- 	mods = "CTRL",
-- -- 	-- 	-- 	action = wezterm.action_callback(toggle_acrylic),
-- -- 	-- 	-- },
-- -- 	-- 	{
-- -- 	-- 		mods = "CTRL|ALT",
-- -- 	-- 		key = "b",
-- -- 	-- 		action = wezterm.action.EmitEvent("toggle-acrylic"),
-- -- 	-- 	},
-- -- 	-- },
-- -- 	-- colors = {
-- -- 	-- 	-- cursor_bg = '#52ad70',  -- Background color of the cursor
-- -- 	-- 	cursor_bg = "#3e757f", -- Background color of the cursor
-- -- 	-- 	cursor_fg = "black", -- Text color when the cursor is over text
-- -- 	-- 	cursor_border = "#486b61", -- Border color of the cursor
-- -- 	-- 	visual_bell = "#392061",
-- -- 	-- },
-- -- 	-- env = {
-- -- 	-- 	LANG = "en_US.UTF-8",
-- -- 	-- 	TERM = "wezterm",
-- -- 	-- },
-- -- 	-- TERM = "wezterm",
-- -- 	-- default_cursor_style = "BlinkingBlock",
-- -- 	-- force_reverse_video_cursor = true, -- This ensures the cursor color matches the text color
-- -- 	-- enable_kitty_graphics = true,
-- -- 	-- max_fps = 120,
-- -- }
--
-- -- wezterm.set_config_overrides({
-- -- win32_system_backdrop = 'Acrylic',
-- -- -- window_background_opacity = acrylic_enabled and 0.8 or 1.0,
-- --
-- -- })
