-- local lualine = require("config.lualine_util")
return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = {
      "SupermavenUseFree",
      "SupermavenUsePro",
      "SupermavenStart",
      "SupermavenToggle",
    },
    opts = {
      -- keymaps = {
      --   accept_suggestion = nil, -- handled by nvim-cmp / blink.cmp
      -- },
      -- disable_inline_completion = vim.g.ai_cmp,
      ignore_filetypes = { "snacks_input", "snacks_notif" },
    },
  },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   -- optional = true,
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     table.insert(opts.sections.lualine_x, 2, lualine.cmp_source("supermaven"))
  --   end,
  -- },
}
