local lualine = require("config.lualine_util")
return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    opts = {},
    cmd = {
      "SupermavenUseFree",
      "SupermavenUsePro",
      "SupermavenStart",
      "SupermavenToggle",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    -- optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 2, lualine.cmp_source("supermaven"))
    end,
  },
}
