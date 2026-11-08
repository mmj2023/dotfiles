local function layout_bind(bind_table)
    return function ()
        local workspace = hl.get_active_special_workspace() or
                          hl.get_active_workspace()

        if not workspace then
            return
        end

        local layout = workspace.tiled_layout

        if bind_table[layout] then
            hl.dispatch(bind_table[layout])
        end
    end
end
-- hl.gesture({
--   fingers = 3,
--   direction = "up",
--   action = function()
--     hl.notification.create({ text = "I just swiped on my trackpad!", timeout = 5000, icon = "ok" })
--   end
-- })
hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "left",
	action = function ()
     -- hl.exec_cmd("notify-send 'hi'")
     hl.dispatch(layout_bind({
      scrolling = hl.dsp.layout("move -col"),  -- Scrolling: swap column with left one
      dwindle   = hl.dsp.focus({ direction = "right"}),  -- Dwindle: swap window split
      monocle   = hl.dsp.focus({ direction = "right"}),  -- Monocle and master: cycle prev window
      master    = hl.dsp.focus({ direction = "right"}),
     }))
    end,
})
--
hl.gesture({
	fingers = 3,
	direction = "right",
	action = function ()
     -- hl.dsp.layout("focus l")
     hl.dispatch(layout_bind({
      scrolling = hl.dsp.layout("move +col"),  -- Scrolling: swap column with left one
      dwindle   = hl.dsp.focus({ direction = "left"}),  -- Dwindle: swap window split
      monocle   = hl.dsp.focus({ direction = "left"}),  -- Monocle and master: cycle prev window
      master    = hl.dsp.focus({ direction = "left"}),
     }))
    end,
})
if hl.plugin.scrolloverview then
	hl.plugin.scrolloverview.gesture({ fingers = 4, direction = "vertical", disable_inhibit = true })
end
