hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

-- hl.gesture({
-- 	fingers = 3,
-- 	direction = "right",
-- 	action = hl.dsp.focus({ direction = "r" }),
-- })
--
-- hl.gesture({
-- 	fingers = 3,
-- 	direction = "left",
-- 	action = hl.dsp.focus({ direction = "l" })
-- })
hl.plugin.scrolloverview.gesture({ fingers = 4, direction = "vertical", disable_inhibit = true })
