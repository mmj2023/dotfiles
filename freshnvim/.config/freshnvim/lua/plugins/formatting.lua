return {
  {
    "stevearc/conform.nvim",
    dependencies = {
      {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {
          ui = {
            icons = {
              package_pending = " ",
              package_installed = " ",
              package_uninstalled = " ",
            },
          },
        },
      },
    },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format()
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    opts = function()
      ---@type conform.setupOpts
      local opts = {
        default_format_opts = {
          timeout_ms = 3000,
          async = false, -- not recommended to change
          quiet = false, -- not recommended to change
          lsp_format = "fallback", -- not recommended to change
        },
        formatters_by_ft = {
          lua = { "stylua" },
          -- fish = { "fish_indent" },
          sh = { "shfmt" },
          python = { "isort", "black" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          -- ocaml = { "ocamlformat" },
          ocaml = { "ocamlformat", "ocamlformat-rpc", stop_after_first = true },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
          injected = { options = { ignore_errors = true } },
          -- # Example of using dprint only when a dprint.json file is present
          dprint = {
            condition = function(ctx)
              return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
            end,
          },

          -- # Example of using shfmt with extra args
          shfmt = {
            prepend_args = {
              "-i",
              "2",--[[  "-ci"  ]]
            },
          },
        },
      }
      return opts
    end,
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
