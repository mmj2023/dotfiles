return {
  {
    "FerretDetective/oil-git-signs.nvim",
    ft = "oil",
    ---@module "oil_git_signs"
    ---@type oil_git_signs.Config
    opts = {},
  },

  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
      win_options = {
        signcolumn = "yes:2",
        statuscolumn = "",
      },
    },
    -- Optional dependencies
    dependencies = {
      {
        "echasnovski/mini.icons", --[[ opts = {} ]]
        "FerretDetective/oil-git-signs.nvim",
      },
    },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
}
