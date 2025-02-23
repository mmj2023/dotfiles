return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    -- vim.cmd([[set showcmd]])
    -- vim.cmd([[set cmdheight=0]])
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    local require = require("lualine_require").require

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
    local function pretty_path()
      local filepath = vim.fn.expand("%:p")
      local cwd = vim.fn.getcwd()
      local root_dir = cwd

      -- If using LSP, get the root directory

      local clients = vim.lsp.get_clients()
      if next(clients) ~= nil then
        for _, client in pairs(clients) do
          if client.config.root_dir then
            root_dir = client.config.root_dir
            break
          end
        end
      end

      -- Make the path relative to the root directory
      local relative_path = vim.fn.fnamemodify(filepath, ":~:.")
      return relative_path
    end
    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = "auto",
        icons_enabled = true,
        component_separators = { left = " ", right = " " },
        section_separators = { left = "", right = "" },
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            icon = "",
            color = { fg = "#b4b4b4" },
            separator = {
              right = "",
              right_padding = 2,
            },
          },
        },
        lualine_b = {
          {
            "branch",
            icon = { "" },
            color = { bg = "#303030" },
            separator = { left = "", right = "" },
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
            separator = "",
          },
        },

        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 2, right = -2 } },
          { pretty_path, separator = "" },
          {
            "diagnostics",
            icon = { "  :" },
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
            padding = { left = 0, right = 0 },
            separator = "",
          },
        },
        lualine_x = {
            -- stylua: ignore
            -- {
            --     function()
            --         return vim.api.nvim_exec('echo getcmdline()', true)
            --     end,
            --     separator = '',
            -- },
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = { fg = "#ff966c"},
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = "#ff7d50" },
            },
        },
        lualine_y = {
          { "encoding", color = { bg = "#303030" }, padding = { left = 1, right = 1 } },
          { "fileformat", color = { bg = "#303030" }, padding = { left = 1, right = 1 } },
          {
            "filetype",
            color = { bg = "#303030" },
            separator = "",
            padding = { left = 1, right = 1 },
          },
          {
            "progress",
            color = { bg = "#303030" },
            separator = " ",
            padding = { left = 1, right = 1 },
          },
        },
        lualine_z = {
          {
            "location",
            color = { fg = "#b4b4b4" },
            padding = {
              left = 1,
              right = 1,
            },
          },
        },
      },
      extensions = { "lazy", "oil", "fugitive" },
    }
    local in_tmux = os.getenv("TMUX") ~= nil
    if not in_tmux then
      opts.sections.lualine_z = {
        {
          "location",
          color = { fg = "#b4b4b4" },
          padding = {
            left = 1,
            right = 0,
          },
        },
        function()
          return " " .. os.date("%R")
        end,
      }
    end
    return opts
  end,
}
