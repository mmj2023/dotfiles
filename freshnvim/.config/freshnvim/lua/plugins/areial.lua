return {
  desc = "Aerial Symbol Browser",
  {
    "stevearc/aerial.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    opts = function()
      local icons = {
        misc = {
          dots = "󰇘",
        },
        ft = {
          octo = "",
        },
        dap = {
          Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
          Breakpoint = " ",
          BreakpointCondition = " ",
          BreakpointRejected = { " ", "DiagnosticError" },
          LogPoint = ".>",
        },
        diagnostics = {
          Error = " ",
          Warn = " ",

          Hint = " ",

          Info = " ",
        },
        git = {
          added = " ",
          modified = " ",
          removed = " ",
          changedelete = "󱕖 ",
        },
        kinds = {
          Array = " ",

          Boolean = "󰨙 ",
          Class = " ",
          Codeium = "󰘦 ",
          Color = " ",
          Control = " ",
          Collapsed = " ",
          Constant = "󰏿 ",
          Constructor = " ",
          Copilot = " ",
          Enum = " ",
          EnumMember = " ",
          Event = " ",
          Field = " ",
          File = " ",
          Folder = " ",
          Function = "󰊕 ",
          Interface = " ",
          Key = " ",
          Keyword = " ",

          Method = "󰊕 ",
          Module = " ",
          Namespace = "󰦮 ",
          Null = " ",
          Number = "󰎠 ",

          Object = " ",

          Operator = " ",
          Package = " ",
          Property = " ",
          Reference = " ",
          Snippet = " ",
          String = " ",
          Struct = "󰆼 ",

          TabNine = "󰏚 ",
          Text = " ",
          TypeParameter = " ",
          Unit = " ",

          Value = " ",

          Variable = "󰀫 ",
        },
      }
      -- HACK: fix lua's weird choice for `Package` for control
      -- structures like if/else/for/etc.
      icons.lua = { Package = icons.Control }
      local filter_kind = false

      ---@type table<string, string[]|boolean>?
      local kind_filter = {
        default = {
          "Class",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Package",
          "Property",
          "Struct",
          "Trait",
        },
        markdown = false,
        help = false,
        -- you can specify a different filter for each filetype
        lua = {
          "Class",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          -- "Package", -- remove package since luals uses it for control flow structures
          "Property",
          "Struct",
          "Trait",
        },
      }
      if kind_filter then
          filter_kind = assert(kind_filter)
        filter_kind._ = filter_kind.default
        filter_kind.default = nil
      end
      local opts = {
        attach_mode = "global",
        backends = { "lsp", "treesitter", "markdown", "man" },
        show_guides = true,
        layout = {
          resize_to_content = false,
          win_opts = {
            winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
            signcolumn = "yes",
            statuscolumn = " ",
          },
        },
        -- icons = icons,
        filter_kind = filter_kind,
        -- stylua: ignore
        guides = {
          mid_item   = "├╴",
          last_item  = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },
      }
      return opts
    end,
    keys = {
      { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
    },
  },
  {
    "folke/trouble.nvim",
    optional = true,
    keys = {
      { "<leader>cs", false },
    },
  },
  -- lualine integration
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  -- if not vim.g.trouble_lualine then
  -- table.insert(opts.sections.lualine_c, {
  --   "aerial",
  --   sep = " ", -- separator between symbols
  --   sep_icon = "", -- separator between icon and symbol
  --
  --   -- The number of symbols to render top-down. In order to render only 'N' last
  --   -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
  --   -- be used in order to render only current symbol.
  --   depth = 5,
  --
  --   -- When 'dense' mode is on, icons are not rendered near their symbols. Only
  --   -- a single icon that represents the kind of current symbol is rendered at
  --   -- the beginning of status line.
  --   dense = false,
  --
  --   -- The separator to be used to separate symbols in dense mode.
  --   dense_sep = ".",
  --
  --   -- Color the symbol icons.
  --   colored = true,
  -- })
  -- end
  --   end,
  -- },
}
