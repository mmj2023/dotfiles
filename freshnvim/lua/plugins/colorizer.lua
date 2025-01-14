return {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    opts = {},
    config = function(_ ,opts)
        require('colorizer').setup(opts)
    end,
}
