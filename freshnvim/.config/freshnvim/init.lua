--[[
=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-''''''''''''''''''-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   | === |          ========
========         ||     FreshNVIM      ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================
=====================================================================
=====================================================================
=====================================================================
--]]
-- -- Helper: check if a file exists
-- local function file_exists(path)
--   local f = io.open(path, "rb")
--   if f then
--     f:close()
--   end
--   return f ~= nil
-- end

-- -- Helper: get modification time (in seconds) of a file using Neovim’s libuv
-- local function get_mod_time(path)
--   local stat = vim.loop.fs_stat(path)
--   return stat and stat.mtime.sec or 0
-- end

-- -- Helper: compile a Lua source file into bytecode using LuaJIT.
-- -- It uses vim.fn.system for synchronous execution.
-- local function compile_file(src, dst)
--   local cmd = string.format('luajit -b %q %q', src, dst)
--   vim.fn.system(cmd)
-- end

-- local function require_or_dofile(path)
--   if file_exists(path .. ".luac") then
--     dofile(path .. ".luac")
--     --   vim.notify("Error: file not found: " .. path)
--     -- return
--   else
--     path = path .. ".lua"
--     local ok, mod = pcall(require, path)
--     if not ok then
--       vim.notify("Error: failed to load file: " .. path)
--       return
--     end
--   end
--   return mod
-- end
-- import all settings
require("options")
-- dofile("compiled_options.luac")
-- Bootstrap lazy.nvim
-- put this in your main init.lua file ( before lazy setup )
-- vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46_cache/"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local opts = {
  --   -- install = { colorscheme = { "tokyonight", "habamax" } },
}
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { "folke/snacks.nvim", event = "VeryLazy", priority = 10000 },
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  -- checker = { enabled = false },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },
  cache = {
    enabled = true, -- Enable caching for faster startup
  },
  defaults = {
    -- By default, only FreshVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  performance = {
    rtp = {
      reset = true, -- Reset runtime path to improve startup time
      -- disable some rtp plugins
      disabled_plugins = {
        -- "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        -- "tarPlugin",
        -- "tohtml",
        -- "tutor",
        -- "zipPlugin",
      },
    },
  },
  opts,
})
-- vim.defer_fn(function()
-- Your heavy computations here
-- require("lazy_setup")
-- dofile("~/.config/freshnvim/lua/compiled_lazy_setup.luac")
require("custom_auto_commands")
require("keymaps")
-- require_or_dofile("compiled_custom_auto_commands.luac")
-- require_or_dofile("compiled_keymaps.luac")
-- dofile("compiled_custom_auto_commands.luac")
-- dofile("~/.config/freshnvim/lua/compiled_keymaps.luac")
-- end, 40)
