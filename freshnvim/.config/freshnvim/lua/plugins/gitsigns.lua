return {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'BufEnter',
    opts = {
        signs = {
            add = { text = '' },
            change = { text = '' },
            delete = { text = '' },
            topdelete = { text = '' },
            changedelete = { text = '󱕖' },
        },
        sign_priority = 4,
        update_debounce = 100,
        status_formatter = nil, -- Use default
    },
    config = function(_, opts)
        -- vim.keymap.set('n', '<leader>gp', 'Gitsigns prev_hunk', { noremap = true, silent = true })
        -- vim.keymap.set('n', '<leader>gtb', 'Gitsigns toggle_current_line_blame', { noremap = true, silent = true })
        require('gitsigns').setup(opts)
    end,
    keys = {
        {'<leader>tb', "<cmd>Gitsigns toggle_current_line_blame<cr>",desc = 'Toggle current line blame',},
        {'<leader>gp',"<cmd>Gitsigns prev_hunk<cr>",desc = 'Preview the git hunk',},
    },
}
