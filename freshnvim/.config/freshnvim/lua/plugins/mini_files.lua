return { 'echasnovski/mini.files',
    version = false,
    event = {--[[  'BufReadPost', 'BufWinEnter'  ]]'VeryLazy',}, -- Load on buffer read or window enter
    opts = {
    -- General options
        options = {
            -- Whether to delete permanently or move into module-specific trash
            permanent_delete = false,
            -- Whether to use for editing directories
            use_as_default_explorer = false,
        },
    },
}
