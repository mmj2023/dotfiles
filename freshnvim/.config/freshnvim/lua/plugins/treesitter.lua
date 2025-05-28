local M = {}

-- foldtext for Neovim < 0.10.0
function M.foldtext()
  return vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1]
end

-- optimized treesitter foldexpr for Neovim >= 0.10.0
function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b[buf].ts_folds == nil then
    -- as long as we don't have a filetype, don't bother
    -- checking if treesitter is available (it won't)
    if vim.bo[buf].filetype == "" then
      return "0"
    end
    if vim.bo[buf].filetype:find("dashboard") then
      vim.b[buf].ts_folds = false
    else
      vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
    end
  end
  return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
end

return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  event = { --[[ "BufReadPost", "BufNewFile", "BufWritePre", ]]
    "FreshFile",
    "VeryLazy",
  },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  build = ":TSUpdate",
  main = "nvim-treesitter.configs", -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "html",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
      "printf",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "ocaml",
      "typescript",
      "xml",
      "yaml",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true, disable = { "ruby" } },
  },
  ---@param opts TSConfig
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    -- Set foldtext
    -- end
    local version = vim.version()

    -- Check if Neovim is >= 0.10.0
    if version.major > 0 or (version.major == 0 and version.minor >= 10) then
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.M.foldexpr()"
    else
      vim.opt.foldmethod = "manual" -- or another fallback method
      vim.opt.foldtext = "v:lua.M.foldtext()"
    end
  end,
  keys = {
    { "<c-space>", desc = "Increment Selection" },
    { "<bs>", desc = "Decrement Selection", mode = "x" },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    enabled = true,
    opts = {
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({ textobjects = opts.textobjects })
      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
  {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    event = { --[[ "BufReadPost", "BufNewFile", "BufWritePre", ]]
      "VeryLazy",
      "FreshFile",
    },
  },
  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = {
      "FreshFile",
    },
    opts = {
      -- Defaults
      -- enable_close = true, -- Auto close tags
      -- enable_rename = true, -- Auto rename pairs of tags
      -- enable_close_on_slash = false, -- Auto close on trailing </
    },
  },
}
