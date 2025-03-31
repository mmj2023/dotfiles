-- My options

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
vim.o.mousemoveevent = true
vim.opt.scrolloff = 8

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- -- use color column if you want to
-- vim.opt.colorcolumn = "80"

-- lower the load time
vim.loader.enable()
-- Decrease update time
vim.opt.updatetime = 50

-- indent rules
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
-- Enable break indent
vim.opt.breakindent = true

-- vim.opt.laststatus = 3
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.termguicolors = true
vim.wo.number = true
vim.o.pumblend = 0
vim.o.winblend = 0

-- listchars
vim.opt.list = true
vim.opt.listchars = {
        eol = '↴',
        tab = '» ',
        trail = '•',
        nbsp = '␣',
}


-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Save undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd [[set cmdheight=1]]
-- vim.cmd [[set wildmenu]]
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- vim.g.python3_host_prog = "/usr/bin/python"
-- vim.opt.nofoldenable = false
-- disable snacks animations
-- I find the animations a bit laggy
-- vim.g.snacks_animate = false
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
