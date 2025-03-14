return {
  "echasnovski/mini.animate",
  event = "VeryLazy",
  cond = vim.g.neovide == nil,
  opts = function(_, opts)
    -- don't use animate when scrolling with the mouse
    local mouse_scrolled = false
    for _, scroll in ipairs({ "Up", "Down" }) do
      local key = "<ScrollWheel" .. scroll .. ">"
      vim.keymap.set({ "", "i" }, key, function()
        mouse_scrolled = true
        return key
      end, { expr = true })
    end
    local animate = require("mini.animate")
    return vim.tbl_deep_extend("force", opts, {
      resize = {
        timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
      },
      scroll = {
        timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        subscroll = animate.gen_subscroll.equal({
          predicate = function(total_scroll)
            if mouse_scrolled then
              mouse_scrolled = false
              return false
            end
            return total_scroll > 1
          end,
        }),
      },
    })
  end,
  keys = {
    {
      "<leader>ua",
      function()
        require("mini.animate").toggle()
      end,
      desc = "Mini Animate toggle",
    },
  },
}
