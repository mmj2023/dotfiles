return {
  "xiyaowong/transparent.nvim",
  lazy = true,
  event = "VeryLazy",
  config = function()
    --setting up transparent.nvim
    require("transparent").setup({
      -- enable = true,
      extra_groups = { -- table/string: additional groups that should be cleared
        "BufferLineTabClose",
        "BufferlineBufferSelected",
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineSeparator",
        "BufferLineIndicatorSelected",

        -- "IndentBlanklineChar",

        -- make floating windows transparent
        "LspFloatWinNormal",
        "Normal",
        "NormalFloat",
        "FloatBorder",
        "TelescopeNormal",
        "TelescopeBorder",
        "TelescopePromptBorder",
        "SagaBorder",
        "CursorLine",
        "SagaNormal",
        "WinBar",
      },
      exclude_groups = {
        "Comment",
        "String",
        "Constant",
        "Special",
        -- "CursorLine",
        "ColorColumn",
        "colorizer.highlight_buffer",
        "Colorize",
      }, -- table: groups you don't want to clear
    })
    require("transparent").clear_prefix("barbecue")
    require("transparent").clear_prefix("Lualine")
    require("transparent").clear_prefix("fidget")
    -- require('transparent').clear_prefix('BufferLine')
    -- require('transparent').clear_prefix("mason")
    vim.keymap.set("n", "<Space>td", function()
      -- -- Get the current colorscheme
      -- -- Function to get the current colorscheme
      -- local function get_current_colorscheme()
      --     local current_colorscheme = vim.api.nvim_exec('echo g:colors_name', true)
      --     return current_colorscheme
      -- end
      -- local current_colorscheme = get_current_colorscheme()
      vim.cmd("TransparentDisable")
      -- vim.cmd('colorscheme nvchad')
      -- vim.cmd('colorscheme ' .. current_colorscheme)
      local bg_color = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg")
      vim.fn.system('if [ -n "$TMUX" ]; then tmux set-option status-style bg=' .. bg_color .. "; fi")
    end, { noremap = true, silent = true })
    function TE()
      vim.cmd("Lazy load transparent.nvim")
      vim.cmd("set nocursorcolumn")
      vim.cmd("TransparentEnable")
    end
    vim.keymap.set("n", "<leader>te", function()
      vim.cmd("lua TE()")
      -- vim.fn.system("if [ -z \"$TMUX\" ]; then tmux set-option status-style bg=default; fi")
      vim.fn.system('if [ -n "$TMUX" ]; then tmux set-option status-style bg=default; fi')
    end, { noremap = true, silent = true })
    vim.cmd("TransparentEnable")
  end,
}
