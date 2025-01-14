return {
    "supermaven-inc/supermaven-nvim",
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    config = function()
        require("supermaven-nvim").setup({})
    end,
}
