local terminal = "prime-run kitty"
local fileManager = "prime-run nemo"
local menu = "rofi -show run"

-- === Window Management ===
-- hl.bind("SUPER+ Q", "killactive")
-- local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind("SUPER+ Q", hl.dsp.window.close())
-- hl.bind("SUPER+ F", "fullscreen 0")
hl.bind("SUPER+ F", hl.dsp.window.fullscreen(1,1))
-- hl.bind("SUPER+SHIFT+ F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER+SHIFT+ F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
-- hl.bind("SUPER SHIFT+ F", "fullscreenstate 1 0")
-- hl.bind("SUPER SHIFT+ F", hl.dsp.window.fullscreen_state(0,1))
-- hl.bind("SUPER+SHIFT+ T", "togglefloating")
hl.bind("SUPER+SHIFT+ Y", hl.dsp.window.float())

hl.bind("SUPER+CTRL+ W", hl.dsp.group.toggle(), {description = "Toggle group"})
-- hl.bind("SUPER CTRL+ W", hl.dsp.group)
-- hl.bind("SUPER+ U", "lockactivegroup toggle")
hl.bind("SUPER+ U", hl.dsp.group.lock_active())
local mainMod = "SUPER"

-- need to be checked
-- hl.bind("SUPER+ W", hl.dsp.group.active()) -- this was not the one
hl.bind("SUPER + W", hl.dsp.group.next())
hl.bind("SUPER+SHIFT+ W", hl.dsp.group.prev())


hl.bind("ALT+ Tab", hl.dsp.window.cycle_next())
hl.bind("ALT+SHIFT+ Tab", hl.dsp.window.cycle_next("prev"))

-- === OCR & Utilities ===
-- hl.bind("SUPER+SHIFT+ Y", hl.dsp.exec_cmd([[exec grim "$(slurp)" /tmp/ocr.png && tesseract /tmp/ocr.png stdout | wl-copy && notify-send -i ~/Pictures/icons/hyprland.icon "Hyprland" "Text copied to clipboard"]]))
hl.bind("SUPER+SHIFT+ T", hl.dsp.exec_cmd([[grim -g "$(slurp)" /tmp/ocr.png && tesseract /tmp/ocr.png stdout | wl-copy && notify-send -i ~/Pictures/icons/hyprland.icon "Hyprland" "Text copied to clipboard"]]))
hl.bind("SUPER+ O", hl.dsp.exec_cmd([[ADDR=$(hyprctl -j activewindow | /usr/bin/jq -r .address); val=$(hyprctl getprop \"address:$ADDR\" opacity); if [ \"$val\" = \"0.65\" ]; then hyprctl -q dispatch setprop \"address:$ADDR\" opacity 1; hyprctl -q dispatch setprop \"address:$ADDR\" opacity_inactive 1; hyprctl -q dispatch setprop \"address:$ADDR\" opacity_fullscreen 1; else hyprctl -q dispatch setprop \"address:$ADDR\" opacity 0.65; hyprctl -q dispatch setprop \"address:$ADDR\" opacity_inactive 0.65; hyprctl -q dispatch setprop \"address:$ADDR\" opacity_fullscreen 0.65; fi]]))
-- toggle blur + game mode
hl.bind("SUPER + F1", function ()
    local game_mode = (hl.get_config("animations.enabled") == false)

    if game_mode then
        hl.exec_cmd("hyprctl reload")
        return
    end

    hl.config({
        general = {
            gaps_in = 0, gaps_out = 0, -- Disable gaps
            border_size = 0,
        },

        animations = {
            enabled = false, -- Disable animations
        },

        -- Disable blur, shadow and window rounding
        decoration = {
            shadow = { enabled = false },
            blur = { enabled = false },
            rounding = 0,
        }
    })
end)

hl.bind("SUPER + B", function ()
    local blur_mode = (hl.get_config("decoration.blur.enabled") == true)

    if blur_mode then
        hl.exec_cmd("hyprctl reload")
        return
    end

    hl.config({
        -- general = {
        --     gaps_in = 0, gaps_out = 0, -- disable gaps
        --     border_size = 0,
        -- },

        -- animations = {
        --     enabled = false, -- Disable animations
        -- },

        -- Disable blur, shadow and window rounding
        decoration = {
            shadow = { enabled = false },
            blur = { enabled = true },
            rounding = 0,
        }
    })
end)

hl.bind("SUPER + SHIFT+ B", function ()
    local game_mode = (hl.get_config("animations.enabled") == false)

    if game_mode then
        hl.exec_cmd("hyprctl reload")
        return
    end

    hl.config({
        -- general = {
        --     gaps_in = 0, gaps_out = 0, -- Disable gaps
        --     border_size = 0,
        -- },

        animations = {
            enabled = false, -- Disable animations
        },

        -- -- Disable blur, shadow and window rounding
        -- decoration = {
        --     shadow = { enabled = false },
        --     blur = { enabled = false },
        --     rounding = 0,
        -- }
    })
end)
-- hl.bind("SUPER+ B", hl.dsp.exec_cmd("bash /home/mdmmj/toggle_blur.sh"))
-- hl.bind("SUPER CTRL+ C", "exec hyprctl kill")
-- hl.bind(mainMod .. "+ CTRL + C", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind("SUPER+SHIFT+ C", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker | wl-copy"))

-- === Window Movement ===
hl.bind("SUPER+SHIFT+ left",hl.dsp.window.move({ direction = "left"}))
hl.bind("SUPER+SHIFT+ down", hl.dsp.window.move({ direction = "down"}))
hl.bind("SUPER+SHIFT+ up", hl.dsp.window.move({ direction = "up"}))
hl.bind("SUPER+SHIFT+ right", hl.dsp.window.move({ direction = "right"}))
hl.bind("SUPER+SHIFT+ H", hl.dsp.window.move({ direction = "left"}))
hl.bind("SUPER+SHIFT+ J", hl.dsp.window.move({ direction = "down"}))
hl.bind("SUPER+SHIFT+ K", hl.dsp.window.move({ direction = "up"}))
hl.bind("SUPER+SHIFT+ L", hl.dsp.window.move({ direction = "right"}))

-- === Column Management ===
hl.bind("SUPER + bracketleft", hl.dsp.layout("preselect l"))
hl.bind("SUPER + bracketright", hl.dsp.layout("preselect r"))
-- === Column Management & Sizing ===
-- hl.bind("SUPER+ R", "layoutmsg togglesplit")
hl.bind("SUPER + R", hl.dsp.layout("togglesplit"))
-- hl.bind("SUPER CTRL+ F", "resizeactive exact 100%")

-- === Focus Navigation ===
hl.bind("SUPER+ left", hl.dsp.focus({ direction = "left"}))
hl.bind("SUPER+ down", hl.dsp.focus({ direction = "down"}))
hl.bind("SUPER+ up", hl.dsp.focus({ direction = "up"}))
hl.bind("SUPER+ right", hl.dsp.focus({ direction = "right"}))
hl.bind("SUPER+ H", hl.dsp.focus({ direction = "left"}))
hl.bind("SUPER+ J", hl.dsp.focus({ direction = "down"}))
hl.bind("SUPER+ K", hl.dsp.focus({ direction = "up"}))
hl.bind("SUPER+ L", hl.dsp.focus({ direction = "right"}))

-- -- === Workspace Management ===
-- hl.bind("CTRL + SHIFT + R", hl.dsp.exec_cmd("dms ipc call workspace-rename open"))

-- Mouse Dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

hl.bind("SUPER + code:20", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { description = "Expand window left" })
hl.bind("SUPER + code:21", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { description = "Shrink window left" })
-- hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
-- hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
-- hl.bind("SUPER+ mouse:272", "movewindow", { click = true, drag = true, desc = "Move window" })
-- hl.bind("SUPER+ mouse:273", "resizewindow", { click = true, drag = true, desc = "Resize window" })

-- hl.bind("SUPER+ code:20", "resizeactive -100 0", { desc = "Expand window left" })
-- hl.bind("SUPER+ code:21", "resizeactive 100 0", { desc = "Shrink window left" })
-- === Mouse Wheel Navigation ===
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + CTRL + mouse_down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + CTRL + mouse_up", hl.dsp.window.move({ workspace = "e-1" }))

-- === Monitor Navigation ===
-- hl.bind("SUPER CTRL+ left", hl.dsp.focus({monitor}))
-- hl.bind("SUPER CTRL+ right", "focusmonitor r")
-- hl.bind("SUPER CTRL+ H", "focusmonitor l")
-- hl.bind("SUPER CTRL+ J", "focusmonitor d")
-- hl.bind("SUPER CTRL+ K", "focusmonitor u")
-- hl.bind("SUPER CTRL+ L", "focusmonitor r")
hl.bind("SUPER + CTRL + left", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + CTRL + right", hl.dsp.focus({ monitor = "r" }))
hl.bind("SUPER + CTRL + H", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + CTRL + J", hl.dsp.focus({ monitor = "d" }))
hl.bind("SUPER + CTRL + K", hl.dsp.focus({ monitor = "u" }))
hl.bind("SUPER + CTRL + L", hl.dsp.focus({ monitor = "r" }))

-- === Move to Monitor ===
-- hl.bind("SUPER SHIFT CTRL+ left", "movewindow mon:l")
-- hl.bind("SUPER SHIFT CTRL+ down", "movewindow mon:d")
-- hl.bind("SUPER SHIFT CTRL+ up", "movewindow mon:u")
-- hl.bind("SUPER SHIFT CTRL+ right", "movewindow mon:r")
-- hl.bind("SUPER SHIFT CTRL+ H", "movewindow mon:l")
-- hl.bind("SUPER SHIFT CTRL+ J", "movewindow mon:d")
-- hl.bind("SUPER SHIFT CTRL+ K", "movewindow mon:u")
-- hl.bind("SUPER SHIFT CTRL+ L", "movewindow mon:r")
hl.bind("SUPER + SHIFT + CTRL + left", hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + SHIFT + CTRL + down", hl.dsp.window.move({ monitor = "d" }))
hl.bind("SUPER + SHIFT + CTRL + up", hl.dsp.window.move({ monitor = "u" }))
hl.bind("SUPER + SHIFT + CTRL + right", hl.dsp.window.move({ monitor = "r" }))
hl.bind("SUPER + SHIFT + CTRL + H", hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + SHIFT + CTRL + J", hl.dsp.window.move({ monitor = "d" }))
hl.bind("SUPER + SHIFT + CTRL + K", hl.dsp.window.move({ monitor = "u" }))
hl.bind("SUPER + SHIFT + CTRL + L", hl.dsp.window.move({ monitor = "r" }))

-- === Screenshots ===
-- hl.bind("+ XF86Launch1", "exec grimblast copy area")
-- hl.bind("Print", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind("Print", hl.dsp.exec_cmd("dms screenshot"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("dms screenshot full"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("dms screenshot window"))
-- hl.bind("CTRL+ Print", "exec grimblast copy screen")
-- hl.bind("ALT+ Print", "exec grimblast copy active")
hl.bind("XF86Launch1", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind("CTRL+ XF86Launch1", hl.dsp.exec_cmd("grimblast copy screen"))
hl.bind("ALT+ XF86Launch1", hl.dsp.exec_cmd("grimblast copy active"))
hl.bind("SUPER+SHIFT+ S", hl.dsp.exec_cmd("flameshot gui"))
hl.bind("SUPER+ X", hl.dsp.exec_cmd("wayscriber --daemon-toggle"))

-- === System Controls ===
hl.bind("SUPER + SHIFT + P", hl.dsp.dpms({ action = "toggle" }))
hl.bind("SUPER+CTRL+ P", hl.dsp.exec_cmd("systemctl suspend || loginctl suspend"))
hl.bind("SUPER+CTRL+SHIFT+ P", hl.dsp.exec_cmd("wlogout"))



-- === Zoom in/out ===
local MAX_ZOOM = 10
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1.5

---@param offset number
---@return nil
local function zoom(offset)
    local current = hl.get_config("cursor.zoom_factor")
    if offset ~= nil then
        current = current + offset
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    else
        current = ZOOM_TOGGLE_FACTOR
    end
    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end
hl.bind("SUPER+ minus", function()
    zoom(-0.5)
end)
hl.bind("SUPER+ equal", function()
    zoom(0.5)
end)
hl.bind("SUPER+SHIFT+ equal", zoom)
-- hl.bind("SUPER+SHIFT+ equal", hl.dsp.exec_cmd([[hyprctl keyword cursor:zoom_factor 1.0]]))
-- hl.bind("SUPER+ mouse_up", "exec hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')")
-- hl.bind("SUPER+ mouse_down", "exec hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')")

-- === App Launchers ===
hl.bind("SUPER+ T", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER+ALT+W", hl.dsp.exec_cmd("~/dotfiles/sh_bin/.local/bin/launch_vgpu.sh"))
hl.bind("SUPER+SHIFT+ space", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
hl.bind("SUPER+ALT+SHIFT+ space", hl.dsp.exec_cmd(menu))
hl.bind("SUPER+ space", hl.dsp.exec_cmd("nc -U /run/user/1000/walker/walker.sock"))
hl.bind("SUPER+ALT+ space", hl.dsp.exec_cmd("krunner"))
-- hl.bind("+ F12", "pass class:^(com\\.obsproject\\.Studio)$")
-- hl.bind("F12", "pass class:^(com\\.obsproject\\.Studio)$")
hl.bind("F12", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }))
hl.bind("SUPER+ V", hl.dsp.exec_cmd("copyq toggle"))
hl.bind("SUPER+SHIFT+ V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
hl.bind("SUPER+ E", hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER+ M", hl.dsp.exec_cmd("dms ipc call processlist toggle"))
hl.bind("SUPER+ comma", hl.dsp.exec_cmd("dms ipc call settings toggle"))
hl.bind("SUPER+ N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind("SUPER+SHIFT+ N", hl.dsp.exec_cmd("dms ipc call notepad toggle"))
hl.bind("SUPER+CTRL+ V", hl.dsp.exec_cmd("voxtype record start"))
hl.bind("SUPER+CTRL+ V", hl.dsp.exec_cmd("voxtype record stop", { release = true }))

-- === Navigation ===
hl.bind("SUPER + Home", hl.dsp.focus({ window = "first" }))
hl.bind("SUPER + End", hl.dsp.focus({ window = "last" }))
hl.bind("SUPER+ S", hl.dsp.focus({ workspace = "m+1"}))
hl.bind("SUPER+ A", hl.dsp.focus({ workspace = "m-1"}))
hl.bind("SUPER+ Tab", hl.dsp.focus({ workspace = "previous"}))
-- hl.bind("SUPER+ALT+ O", hl.dsp.exec_cmd("hyprctl dispatch overview:toggle"))
-- Toggle ScrollOverview with SUPER+g
hl.bind("SUPER+ALT+ O", function()
    hl.plugin.scrolloverview.overview("toggle all")
end)
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER+ KP_Prior", hl.dsp.focus({ workspace = "e+1"}))
hl.bind("SUPER+ KP_Next", hl.dsp.focus({ workspace = "e-1"}))
hl.bind("SUPER + CTRL + down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + CTRL + up", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("SUPER + CTRL + U", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + CTRL + I", hl.dsp.window.move({ workspace = "e-1" }))

-- === Move Workspaces ===
hl.bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("SUPER + SHIFT + U", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + I", hl.dsp.window.move({ workspace = "e-1" }))

-- === Mouse Wheel Navigation ===
hl.bind("SUPER+ALT+ mouse_down", hl.dsp.focus({ workspace = "e+1"}))
hl.bind("SUPER+ALT+ mouse_up", hl.dsp.focus({ workspace = "e-1"}))
hl.bind("SUPER+CTRL+ mouse_down", hl.dsp.window.move({ workspace = "e+1"}))
hl.bind("SUPER+CTRL+ mouse_up", hl.dsp.window.move({ workspace = "e-1"}))
-- hl.bind("SUPER+CTRL+ M", hl.dsp.layout("layoutmsg scrolling")
hl.bind("SUPER+CTRL+ M", function ()
    local layouts     = { "scrolling", "dwindle", "master", "monocle" }
    local workspace   = hl.get_active_workspace()
	if hl.get_active_special_workspace() then
		workspace = hl.get_active_special_workspace()
	end

    local next_layout = "dwindle"

    if not workspace then
        return
    end

    for i = 1, #layouts do
        if layouts[i] == workspace.tiled_layout then
            local next_layout_idx = (i % #layouts) + 1
            next_layout = layouts[next_layout_idx]
            break
        end
    end

	if workspace.special then
		hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
	else
		hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
	end
end)

-- === Audio & Hardware Controls ===
-- hl.bind("+ XF86AudioRaiseVolume", "exec dms ipc call audio increment 3", { repeating = true, locked = true })
-- hl.bind("+ XF86AudioLowerVolume", "exec dms ipc call audio decrement 3", { repeating = true, locked = true })
-- hl.bind("+ XF86AudioMute", "exec dms ipc call audio mute", { locked = true })
-- hl.bind("+ XF86AudioMicMute", "exec dms ipc call audio micmute", { locked = true })
-- hl.bind("+ XF86KbdBrightnessUp", "exec kbdbrite.sh up", { repeating = true, locked = true })
-- hl.bind("+ XF86KbdBrightnessDown", "exec kbdbrite.sh down", { repeating = true, locked = true })
-- hl.bind("+ XF86MonBrightnessUp", "exec dms ipc call brightness increment 5", { repeating = true, locked = true })
-- hl.bind("+ XF86MonBrightnessDown", "exec dms ipc call brightness decrement 5", { repeating = true, locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 3"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("dms ipc call mpris previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("dms ipc call mpris next"), { locked = true })
hl.bind("CTRL + XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call mpris increment 3"), { locked = true, repeating = true })
hl.bind("CTRL + XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call mpris decrement 3"), { locked = true, repeating = true })
-- === Brightness Controls ===
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), { locked = true, repeating = true })
-- hl.bind("XF86KbdBrightnessUp", "exec kbdbrite.sh up", { repeating = true, locked = true })
-- hl.bind("XF86KbdBrightnessDown", "exec kbdbrite.sh down", { repeating = true, locked = true })
-- hl.bind("XF86MonBrightnessUp", "exec dms ipc call brightness increment 5", { repeating = true, locked = true })
-- hl.bind("XF86MonBrightnessDown", "exec dms ipc call brightness decrement 5", { repeating = true, locked = true })

-- hl.bind("+ XF86AudioNext", "exec playerctl next", { locked = true })
-- hl.bind("+ XF86AudioPause", "exec playerctl play-pause", { locked = true })
-- hl.bind("+ XF86AudioPlay", "exec playerctl play-pause", { locked = true })
-- hl.bind("+ XF86AudioPrev", "exec playerctl previous", { locked = true })
-- hl.bind("+ XF86Calculator", "exec qalculate-qt", { locked = true })
-- hl.bind("XF86AudioNext", "exec playerctl next", { locked = true })
-- hl.bind("XF86AudioPause", "exec playerctl play-pause", { locked = true })
-- hl.bind("XF86AudioPlay", "exec playerctl play-pause", { locked = true })
-- hl.bind("XF86AudioPrev", "exec playerctl previous", { locked = true })
hl.bind("XF86Calculator", hl.dsp.exec_cmd("qalculate-qt"))

-- Security module
require("modules.security")
-- require("security")
