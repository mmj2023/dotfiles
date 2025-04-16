-- My options

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"
vim.o.mousemoveevent = true
vim.opt.scrolloff = 8
-- preview live
vim.opt.inccommand = "split"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
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
  eol = "↴",
  tab = "» ",
  trail = "•",
  nbsp = "␣",
}

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Save undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd([[set cmdheight=0]])
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
-- local signs = {
--   -- Define diagnostic signs per severity level
--   [vim.diagnostic.severity.ERROR] = { text = "  ", texthl = "DiagnosticError", numhl = "DiagnosticError" },
--   [vim.diagnostic.severity.WARN] = { text = "  ", texthl = "DiagnosticWarn", numhl = "DiagnosticWarn" },
--   [vim.diagnostic.severity.INFO] = { text = "  ", texthl = "DiagnosticInfo", numhl = "DiagnosticInfo" },
--   [vim.diagnostic.severity.HINT] = { text = "  ", texthl = "DiagnosticHint", numhl = "DiagnosticHint" },
-- }
vim.diagnostic.config({
  virtual_text = {
    current_line = true,
    prefix = "▎", -- Could be '●', '▎', 'x', '■ ', '• ', '◆ ', '∙ ', '✗ ', '✓ ', etc.
    severity = {
      min = vim.diagnostic.severity.HINT,
    },
    format = function(diagnostic)
      local icons = {
        [vim.diagnostic.severity.ERROR] = "  ",
        [vim.diagnostic.severity.WARN] = "  ",
        [vim.diagnostic.severity.INFO] = "  ",
        [vim.diagnostic.severity.HINT] = "  ",
      }
      return icons[diagnostic.severity] .. diagnostic.message
    end,
  },
  signs = true,
  -- signs = {
  --   -- Define diagnostic signs per severity level
  --   [vim.diagnostic.severity.ERROR] = { text = "  ", texthl = "DiagnosticError", numhl = "DiagnosticError" },
  --   [vim.diagnostic.severity.WARN] = { text = "  ", texthl = "DiagnosticWarn", numhl = "DiagnosticWarn" },
  --   [vim.diagnostic.severity.INFO] = { text = "  ", texthl = "DiagnosticInfo", numhl = "DiagnosticInfo" },
  --   [vim.diagnostic.severity.HINT] = { text = "  ", texthl = "DiagnosticHint", numhl = "DiagnosticHint" },
  -- },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    source = "always", -- Or "if_many"
  },
})
vim.lsp.enable("clangd")
if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
-- vim.opt.timeoutlen = vim.g.vscode and 1000 or 400 -- Lower than default (1000) to quickly trigger which-key
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitkeep = "screen"
vim.opt.splitright = true -- Put new windows right of current
-- vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
-- vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
-- vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
-- vim.opt.autowrite = true -- Enable auto write
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
-- vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
-- opt.autowrite = true -- Enable auto write
vim.opt.foldlevel = 99
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.formatoptions = "jcroqlnt" -- tcqj
-- vim.opt.pumblend = 10 -- Popup blend
-- vim.opt.pumheight = 10 -- Maximum number of entries in a popup
-- vim.opt.undolevels = 10000
-- vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
-- vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
-- vim.opt.winminwidth = 5 -- Minimum window width

vim.lsp.config["jdtls"] = {
  cmd = { "jdtls" },
  filetypes = { "java" },
  root_markers = { ".git", "pom.xml", "build.gradle" },
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
    },
  },
}
vim.lsp.enable("jdtls")
vim.lsp.config["ocamllsp"] = {
  cmd = { "ocamllsp" },
  filetypes = { "ocaml", "ocamlinterface", "ocamllex" },
  root_markers = { "dune-project", "dune-workspace" },
  settings = {},
}
vim.lsp.enable("ocamllsp")
