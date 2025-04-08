return {
  "BrunoKrugel/bbq.nvim",
  lazy = true,
  event = { "LspAttach"},
  name = "barbecue",
  version = "*",
  dependencies = {
      {"SmiteshP/nvim-navic", lazy = true},
    -- "nvim-tree/nvim-web-devicons", -- optional dependency
    "echasnovski/mini.icons",
  },
  opts = {
    -- configurations go here
  },
}
