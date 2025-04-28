return {
  "nvzone/showkeys",
  event = "VeryLazy",
  -- event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
  cmd = "ShowkeysToggle",
  opts = {
    -- timeout = 0.5,
    -- maxkeys = 5,
    -- more opts
    positon = "bottom-right",
  },
  config = function(_, opts)
    require("showkeys").setup(opts)
    vim.cmd([[ShowkeysToggle]])
  end,
}
