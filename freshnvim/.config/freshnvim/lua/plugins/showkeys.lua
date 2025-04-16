return {
  "nvzone/showkeys",
  event = "VeryLazy",
  cmd = "ShowkeysToggle",
  opts = {
    timeout = 0.17,
    maxkeys = 5,
    -- more opts
    positon = "bottom-right",
  },
  config = function(_, opts)
    require("showkeys").setup(opts)
        vim.cmd([[ShowkeysToggle]])
  end
}
