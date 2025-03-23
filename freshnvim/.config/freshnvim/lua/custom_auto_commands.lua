local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})
-- detect if the os is wsl and if yes then, syncronize clipboard to it.
local function is_wsl()
  local osrelease_path = "/proc/sys/kernel/osrelease"
  local file = io.open(osrelease_path, "r")
  if not file then
    return false
  end
  local osrelease = file:read("*a")
  file:close()
  return osrelease:lower():match("microsoft") ~= nil
end

if is_wsl() then
  -- print("Running on WSL")
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
  -- else
  -- 	print("Not running on WSL")
end

-- replace spaces with "•" in visual mode
function enable_list()
  vim.cmd("set listchars+=space:•")
  vim.cmd("set list")
end

function disable_list()
  vim.cmd("set listchars-=space:•")
  vim.cmd("set list")
end

-- Set up autocmd for mode changes
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*", -- Apply to all file types (customize as needed)
  callback = function()
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" then
      enable_list()
    else
      disable_list()
    end
  end,
})

-- flash the text being highlighted
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("my-highlight-on-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

function rand_colorscheme()
  math.randomseed(os.time()) -- Set the random seed based on the current time

  local less_preferred_colorschemes = {
    "blue",
    "zaibatsu",
    "darkblue",
    "default",
    "delek",
    "desert",
    "elflord",
    "evening",
    "industry",
    "koehler",
    "lunaperche",
    "morning",
    "murphy",
    "pablo",
    "peachpuff",
    "quiet",
    "retrobox",
    "ron",
    "shine",
    "slate",
    "sorbet",
    "torte",
    "vim",
    "wildcharm",
    "dayfox",
    "dawnfox",
    "rose-pine-dawn",
  }

  local more_preferred_colorschemes = {
    "habamax",
    "eldritch",
    "oxocarbon",
    "poimandres",
    "nightfox",
    "bluloco",
    "helix",
    "nordfox",
    "terafox",
    "nord",
    "carbonfox",
    "duskfox",
    "rose-pine",
    "rose-pine-moon",
    "rose-pine-main",
    "gruvbox",
    "ayu",
    "ayu-dark",
    "ayu-mirage",
    "gruber_darker",
    "night-owl",
    "tokyodark",
    "vague",
  }

  local random_less_preferred = { less_preferred_colorschemes[math.random(#less_preferred_colorschemes)] }
  local all_colorschemes = vim.tbl_extend("force", random_less_preferred, more_preferred_colorschemes)
  return all_colorschemes[math.random(#all_colorschemes)]
end
vim.cmd("colorscheme " .. rand_colorscheme())

-- -- Create an augroup named "RestoreCursorPosition"
-- local group = vim.api.nvim_create_augroup('RestoreCursorPosition', { clear = true })
-- -- Define an autocommand within that group
--
-- vim.api.nvim_create_autocmd('BufReadPost', {
--     group = group,
--     pattern = '*',
--     callback = function()
--         local pos = vim.fn.line('\'"')
--         if pos > 1 and pos <= vim.fn.line('$') then
--             vim.api.nvim_command('normal! g`"')
--         end
--     end,
-- })

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})
-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})
-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "markdown", "text", "plaintex", "typst", "gitcommit", "markdown", "env" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
local delete_trailing_spaces_group = vim.api.nvim_create_augroup("delete_trailing_spaces_group", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = delete_trailing_spaces_group,
  pattern = "*",
  -- callback = function()
  --     local pos = vim.fn.line('\'"')
  --     if pos > 1 and pos <= vim.fn.line('$') then
  --         vim.api.nvim_command('normal! g`"')
  --     end
  -- end,
  command = [[%s/\s\+$//e]],
})
-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
-- vim.api.nvim_create_autocmd('VimEnter', {
--     callback = function()
local in_tmux = os.getenv("TMUX") ~= nil
if in_tmux then
  -- vim.fn.system("tmux set-option status-style bg=default")
  vim.fn.system(
    'tmux set status-right "#{#[bg=#{default_fg},bold]░}#[fg=${default_fg},bg=default] 󰃮 %Y-%m-%d 󱑒 %H:%M "'
  )
  vim.fn.system("tmux set-option status-style bg=default")
  -- vim.fn.system("tmux source-file ~/.tmux.conf")
end
--     end,
-- })
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    local in_tmux = os.getenv("TMUX") ~= nil
    if in_tmux then
      vim.fn.system(
        'tmux set status-right "#{#[bg=#{default_fg},bold]░}#[fg=${default_fg},bg=default] 󰃮 %Y-%m-%d "'
      )
      vim.fn.system("tmux set-option status-style bg=default")
      -- vim.fn.system("tmux source-file ~/.tmux.conf")
    end
  end,
})
-- vim.api.nvim_create_autocmd("FocusGained", {
--   pattern = "*",
--   callback = function()
--     -- Add any command you want to execute when Neovim regains focus
--     print("Welcome back to Neovim!") -- Example action (optional)
--     -- You can also refresh the buffer, reload configs, or synchronize plugins
--     vim.cmd("checktime") -- Refresh buffers in case files were modified externally
--   end,
-- })
-- vim.cmd(string.format([[highlight WinBar1 guifg=%s]], Snacks.util.color("Special")))
-- vim.cmd(string.format([[highlight WinBar2 guifg=%s]], Snacks.util.color("Special")))
-- vim.cmd(string.format([[highlight WinBar3 guifg=%s gui=bold]], Snacks.util.color("Special")))
-- -- Function to get the full path and replace the home directory with ~get_color
-- local function get_winbar_path()
--   local full_path = vim.fn.expand("%:p:h")
--   return full_path:gsub(vim.fn.expand("$HOME"), "~")
-- end
-- Function to get the number of open buffers using the :ls command
-- -- Function to update the winbar
-- local function update_winbar()
--   local home_replaced = get_winbar_path()
--   local buffer_count = get_buffer_count()
--   vim.opt.winbar = "%#WinBar1#%m "
--     .. "%#WinBar2#("
--     .. buffer_count
--     .. ") "
--     -- this shows the filename on the left
--     .. "%#WinBar3#"
--     .. vim.fn.expand("%:t")
--     -- This shows the file path on the right
--     .. "%*%=%#WinBar1#"
--     .. home_replaced
--   -- I don't need the hostname as I have it in lualine
--   -- .. vim.fn.systemlist("hostname")[1]
-- end
-- -- Winbar was not being updated after I left lazygit
-- vim.api.nvim_create_autocmd({ "BufEnter", "ModeChanged" }, {
--   callback = function(args)
--     local old_mode = args.event == "ModeChanged" and vim.v.event.old_mode or ""
--     local new_mode = args.event == "ModeChanged" and vim.v.event.new_mode or ""
--     -- Only update if ModeChanged is relevant (e.g., leaving LazyGit)
--     if args.event == "ModeChanged" then
--       -- Get buffer filetype
--       local buf_ft = vim.bo.filetype
--       -- Only update when leaving `snacks_terminal` (LazyGit)
--       if buf_ft == "snacks_terminal" or old_mode:match("^t") or new_mode:match("^n") then
--         update_winbar()
--       end
--     else
--       update_winbar()
--     end
--   end,
-- })
