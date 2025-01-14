return {
    'mbbill/undotree',
    -- event = {'VeryLazy','BufReadPost', 'BufWinEnter'},
    opts = {},
    config = function()
        -- vim.keymap.set('n', '<leader>u', vim.cmd.undotreetoggle)
    end,
    cmd = {
        'UndotreeToggle',
    },
    keys = {
        {
            '<leader>u',
            -- function()
            --     vim.cmd.UndotreeToggle
            -- end,
            '<cmd>UndotreeToggle<CR>',
            desc = 'undo tree toggle',
        },
    },
}
