-- Security keybindings
-- hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind("SUPER+ALT+SHIFT+ L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER+ALT+ L", hl.dsp.exec_cmd("pidof dms && dms ipc call lock lock || hyprlock"))
-- hl.bind("SUPER SHIFT, E", "exit")
hl.bind(
	"SUPER+SHIFT+ E",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
-- hl.bind("CTRL+ALT+ Delete", hl.dsp.exec_cmd("dms ipc call processlist toggle"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))
