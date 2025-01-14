-- import all settings
require('options')
require('keymaps')
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
    defaults = {
        -- By default, all plugins will be lazy-loaded.
        -- it's set to true for lazy loading the plugins, setting it to true can cause speed issues.
        lazy = true,
        -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
        -- have outdated releases, which may break your Neovim install.
        version = false, -- always use the latest git commit
        -- version = "*", -- try installing the latest stable version for plugins that support semver , if you want to.
    },
    checker = { enabled = true, notify = false },
    ui = {
        icons = {
            ft = '',
            lazy = '󰂠 ' ,
            loaded = '',
            not_loaded = '',
        },
    },
    performance = {
        rtp = {
            reset = false, -- Reset runtime path to improve startup time
        },
        cache = {
            enabled = true, -- Enable caching for faster startup
        },
    },
}
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
  opts,
})
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        local in_tmux = os.getenv('TMUX') ~= nil
        if in_tmux then
            -- vim.fn.system("tmux set-option status-style bg=default")
            vim.fn.system(
                'tmux set status-right "#{#[bg=#{default_fg},bold]░}#[fg=${default_fg},bg=default] 󰃮 %Y-%m-%d 󱑒 %H:%M "'
            )
            vim.fn.system('tmux set-option status-style bg=default')
            -- vim.fn.system("tmux source-file ~/.tmux.conf")
        end
    end,
})
vim.api.nvim_create_autocmd('VimLeave', {
    callback = function()
        local in_tmux = os.getenv('TMUX') ~= nil
        if in_tmux then
            vim.fn.system(
                'tmux set status-right "#{#[bg=#{default_fg},bold]░}#[fg=${default_fg},bg=default] 󰃮 %Y-%m-%d "'
            )
            vim.fn.system('tmux set-option status-style bg=default')
            -- vim.fn.system("tmux source-file ~/.tmux.conf")εé╛
        end
    end,
})
-- put this after lazy setup

-- (method 1, For heavy lazyloaders)
 -- dofile(vim.g.base46_cache .. "defaults")
 -- dofile(vim.g.base46_cache .. "statusline")
require('custom_auto_commands')
