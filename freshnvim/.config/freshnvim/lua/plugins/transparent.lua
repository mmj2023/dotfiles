return {
  "xiyaowong/transparent.nvim",
  lazy = true,
  event = "VeryLazy",
  config = function()
    --setting up transparent.nvim
    require("transparent").setup({
      -- enable = true,
      extra_groups = { -- table/string: additional groups that should be cleared
        "NeoTreeNormal",
        -- "NeoTreeNormalNC",
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
        -- TabLine
        "MiniTablineFill",
        -- "MiniTablineCurrent",
        "MiniTablineVisible",
        "MiniTablineHidden",
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
        "Visual", -- Ensure Visual mode is unaffected
      }, -- table: groups you don't want to clear
    })
    require("transparent").clear_prefix("barbecue")
    require("transparent").clear_prefix("Lualine")
    require("transparent").clear_prefix("fidget")
    -- require('transparent').clear_prefix('BufferLine')
    -- require('transparent').clear_prefix("mason")
    local bg_color = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg")
    vim.keymap.set("n", "<Space>td", function()
      vim.cmd("TransparentDisable")
      -- vim.notify("Transparencies disabled")
      bg_color = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg")
      vim.fn.system('if [ -n "$TMUX" ]; then tmux set-option status-style bg=' .. bg_color .. "; fi")
    end, { noremap = true, silent = true, desc = "Transparent Disable" })
    function TE()
      vim.cmd("Lazy load transparent.nvim")
      vim.cmd("set nocursorcolumn")
      vim.cmd("TransparentEnable")
      -- vim.notify("Transparencies enabled")
    end
    vim.keymap.set("n", "<leader>te", function()
      vim.cmd("lua TE()")
      -- vim.fn.system("if [ -z \"$TMUX\" ]; then tmux set-option status-style bg=default; fi")
      vim.fn.system('if [ -n "$TMUX" ]; then tmux set-option status-style bg=default; fi')
    end, { noremap = true, silent = true, desc = "Transparent Enable" })
    vim.cmd("TransparentEnable")
    -- HACK: keeping visual mode from being affected by transparent.nvim when switching focus
    local in_tmux = os.getenv("TMUX") ~= nil
    vim.api.nvim_create_autocmd("FocusGained", {
      pattern = "*",
      callback = function()
        -- vim.cmd("TransparentDisable")
        -- vim.cmd("TransparentEnable")
        vim.defer_fn(function()
          vim.cmd("TransparentToggle")
          vim.cmd("TransparentToggle")
        end, 10) -- Delay in milliseconds
        if not vim.g.transparent_enabled then
          if in_tmux then
            vim.fn.system(
              'tmux set status-right "#{#[bg=#{default_fg},bold]░}#[fg=${default_fg},bg=default] 󰃮 %Y-%m-%d 󱑒 %H:%M "'
            )
            bg_color = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg")
            vim.fn.system("tmux set-option status-style bg=" .. bg_color)
          end
        else
          if in_tmux then
            vim.fn.system(
              'tmux set status-right "#{#[bg=#{default_fg},bold]░}#[fg=${default_fg},bg=default] 󰃮 %Y-%m-%d 󱑒 %H:%M "'
            )
            vim.fn.system("tmux set-option status-style bg=default")
          end
        end
      end,
    })
  end,
}
