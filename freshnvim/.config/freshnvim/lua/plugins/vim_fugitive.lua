return {
    "tpope/vim-fugitive",
    -- event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    cmd = 'Git',
    keys = {
        { '<leader>gs', vim.cmd.Git, desc = 'Neogit Status' },
    },
}

