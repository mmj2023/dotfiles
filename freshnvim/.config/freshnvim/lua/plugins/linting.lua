return {
  {
    "mfussenegger/nvim-lint",
    -- event = { --[[ "BufReadPost", "BufNewFile", "BufWritePre",  ]]
    --   "VeryLazy",
    -- },
    event = "FreshFile",
    dependencies = {
      {
        "williamboman/mason.nvim",
      --   build = ":MasonUpdate",
      --   opts = {
      --     ui = {
      --       icons = {
      --         package_pending = " ",
      --         package_installed = " ",
      --         package_uninstalled = " ",
      --       },
      --     },
      --     max_concurrent_installers = 10,
      --   },
      --   config = function(_, opts)
      --     require("mason").setup(opts)
      --     -- add binaries installed by mason.nvim to path
      --     local is_windows = vim.fn.has("win32") ~= 0
      --     local sep = is_windows and "\\" or "/"
      --     local delim = is_windows and ";" or ":"
      --     vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH
      --   end,
      },
    },
    opts = {
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        python = { "flake8" },
        javascript = { "eslint" },
        lua = { "luacheck" },
        markdown = { "typos" }, -- Enable `typos` for Markdown files
        text = { "typos" }, -- Enable `typos` for text files
        txt = { "typos" }, -- Enable `typos` for `.txt` files
        -- fish = { "fish" },
        -- Use the "*" filetype to run linters on all filetypes.
        -- ['*'] = { 'global linter' },
        -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
        -- ['_'] = { 'fallback linter' },
      },
      ---@type table<string,table>
      linters = {
        -- -- Example of using selene only when a selene.toml file is present
        selene = {
          condition = function(ctx)
            return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        -- typos = {
        --   args = { "--lang", "en" }, -- Only for English-based files
        -- },
      },
    },
    config = function(_, opts)
      local M = {}

      local lint = require("lint")
      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
          if type(linter.prepend_args) == "table" then
            lint.linters[name].args = lint.linters[name].args or {}
            vim.list_extend(lint.linters[name].args, linter.prepend_args)
          end
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      function M.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function M.lint()
        -- Use nvim-lint's logic first:
        -- * checks if linters exist for the full filetype first
        -- * otherwise will split filetype by "." and add all those linters
        -- * this differs from conform.nvim which only uses the first filetype that has a formatter
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        -- Create a copy of the names table to avoid modifying the original.
        names = vim.list_extend({}, names)

        -- Add fallback linters.
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end

        -- Add global linters.
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        -- Filter out linters that don't exist or don't match the condition.
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then
            print("Linter not found: " .. name)
          end
          return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
        end, names)

        -- Run linters.
        if #names > 0 then
          lint.try_lint(names)
        end
      end
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

      -- signs = {
      --   [vim.diagnostic.severity.ERROR] = "  ",
      --   [vim.diagnostic.severity.WARN] = "  ",
      --   [vim.diagnostic.severity.INFO] = "  ",
      --   [vim.diagnostic.severity.HINT] = "  ",
      -- }
      -- local signs = {
      --   -- Define diagnostic signs per severity level
      --   [vim.diagnostic.severity.ERROR] = { text = "  ", texthl = "DiagnosticError", numhl = "DiagnosticError" },
      --   [vim.diagnostic.severity.WARN] = { text = "  ", texthl = "DiagnosticWarn", numhl = "DiagnosticWarn" },
      --   [vim.diagnostic.severity.INFO] = { text = "  ", texthl = "DiagnosticInfo", numhl = "DiagnosticInfo" },
      --   [vim.diagnostic.severity.HINT] = { text = "  ", texthl = "DiagnosticHint", numhl = "DiagnosticHint" },
      -- }
      -- for type, icon in pairs(signs) do
      --   local hl = "DiagnosticSign" .. type
      --   if vim.fn.has("nvim-0.11") == 1 then
      --     vim.sign.define(hl, {
      --       text = icon, -- The sign text
      --       texthl = hl, -- Highlight group
      --       numhl = hl, -- numberhighlight group
      --     })
      --   else
      --     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      --   end
      -- end
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type

        -- if vim.diagnostic.config then
        --     -- New API in Neovim 0.11+
        --     -- vim.sign.define(hl, {
        --     --   text = icon, -- Sign text
        --     --   texthl = hl, -- Highlight group
        --     --   numhl = hl, -- Number highlight group
        --     -- })
        --   vim.diagnostic.config({
        --     signs = signs,
        --   })
        -- else
        -- Legacy API for older versions
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        -- end
      end
      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = M.debounce(100, M.lint),
      })
    end,
  },
}
