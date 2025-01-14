return {
    'stevearc/oil.nvim',
    event = 'VimEnter',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      view_options = {
        -- Show files and directories that start with "."
            show_hidden = true,
        }
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", --[[ opts = {} ]] } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
