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
-- -- detect if the os is wsl and if yes then, syncronize clipboard to it.
-- local function is_wsl()
--   local osrelease_path = "/proc/sys/kernel/osrelease"
--   local file = io.open(osrelease_path, "r")
--   if not file then
--     return false
--   end
--   local osrelease = file:read("*a")
--   file:close()
--   return osrelease:lower():match("microsoft") ~= nil
-- end

-- if is_wsl() then
--   -- print("Running on WSL")
--   vim.g.clipboard = {
--     name = "WslClipboard",
--     copy = {
--       ["+"] = "clip.exe",
--       ["*"] = "clip.exe",
--     },
--     paste = {
--       ["+"] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--       ["*"] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--     },
--     cache_enabled = 0,
--   }
--   -- else
--   -- 	print("Not running on WSL")
-- end

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
    "zellner",
    "base16-emil",
    "base16-google-light",
    "base16-github",
    "base16-cupcake",
    "base16-dirtysea",
    "base16-sakura",
    "base16-danqing-light",
    "base16-default-light",
    "base16-edge-light",
    "base16-equilibrium-gray-dark",
    "base16-equilibrium-gray-light",
    "base16-equilibrium-light",
    "base16-grayscale-light",
    "base16-gruvbox-light-hard",
    "base16-gruvbox-light-medium",
    "base16-gruvbox-light-soft",
    "base16-gruvbox-material-light-hard",
    "base16-harmonic-light",
    "base16-harmonic16-light",
    "base16-gruvbox-material-light-medium",
    "base16-gruvbox-material-light-soft",
    "base16-windows-nt-light",
    "base16-windows-highcontrast-light",
    "base16-windows-95-light",
    "base16-windows-10-light",
    "base16-unikitty-light",
    "base16-twilight",
    "base16-tokyo-night-terminal-light",
    "base16-tokyo-night-light",
    "base16-tokyo-city-terminal-light",
    "base16-tokyo-city-light",
    "base16-synth-midnight-light",
    "base16-summerfruit-light",
    "base16-standardized-light",
    "base16-solarized-light",
    "base16-solarflare-light",
    "base16-silk-light",
    "base16-shadesmear-light",
    "base16-selenized-white",
    "base16-selenized-light",
    "base16-sagelight",
    "base16-primer-light",
    "base16-precious-light-white",
    "base16-precious-light-warm",
    "base16-papercolor-light",
    "base16-oxocarbon-light",
    "base16-one-light",
    "base16-nord-light",
    "base16-moonlight",
    "base16-measured-light",
    "base16-material-lighter",
    "base16-embers-light",
    "base16-classic-light",
    "base16-atelier-cave-light",
    "base16-atelier-dune-light",
    "base16-atelier-estuary-light",
    "base16-atelier-forest-light",
    "base16-atelier-heath-light",
    "base16-atelier-lakeside-light",
    "base16-atelier-plateau-light",
    "base16-atelier-savanna-light",
    "tokyonight-day",
    "base16-ayu-light",
    "base16-atelier-seaside-light",
    "base16-atelier-sulphurpool-light",
    "catppuccin-latte",
    "base16-catppuccin-latte",
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
    "gruber-darker",
    "night-owl",
    "tokyodark",
    "vague",
    "cold",
    "zenbones",
    "zenburned",
    "zenwritten",
    "base16-3024",
    "base16-apathy",
    "base16-apprentice",
    "base16-ashes",
    "base16-atelier-cave",
    "base16-atelier-dune",
    "base16-atelier-estuary",
    "base16-atelier-forest",
    "base16-atelier-heath",
    "base16-atelier-lakeside",
    "base16-atelier-plateau",
    "base16-atelier-savanna",
    "base16-atelier-seaside",
    "base16-atelier-sulphurpool",
    "base16-atlas",
    "base16-ayu-dark",
    "base16-ayu-mirage",
    "base16-aztec",
    "base16-bespin",
    "base16-black-metal",
    "base16-black-metal-bathory",
    "base16-black-metal-burzum",
    "base16-black-metal-dark-funeral",
    "base16-black-metal-gorgoroth",
    "base16-black-metal-immortal",
    "base16-black-metal-khold",
    "base16-black-metal-marduk",
    "base16-black-metal-mayhem",
    "base16-black-metal-nile",
    "base16-black-metal-venom",
    "base16-blueforest",
    "base16-blueish",
    "base16-brewer",
    "base16-bright",
    "base16-brogrammer",
    "base16-brushtrees",
    "base16-brushtrees-dark",
    "base16-caroline",
    "base16-catppuccin",
    "base16-catppuccin-frappe",
    "base16-catppuccin-latte",
    "base16-catppuccin-macchiato",
    "base16-catppuccin-mocha",
    "base16-chalk",
    "base16-circus",
    "base16-classic-dark",
    "base16-codeschool",
    "base16-colors",
    "base16-cupertino",
    "base16-da-one-black",
    "base16-da-one-gray",
    "base16-da-one-ocean",
    "base16-da-one-paper",
    "base16-da-one-sea",
    "base16-da-one-white",
    "base16-danqing",
    "base16-darcula",
    "base16-darkmoss",
    "base16-darktooth",
    "base16-darkviolet",
    "base16-decaf",
    "base16-deep-oceanic-next",
    "base16-default-dark",
    "base16-dracula",
    "base16-edge-dark",
    "base16-eighties",
    "base16-embers",
    "base16-equilibrium-dark",
    "base16-eris",
    "base16-espresso",
    "base16-eva",
    "base16-eva-dim",
    "base16-evenok-dark",
    "base16-everforest",
    "base16-everforest-dark-hard",
    "base16-flat",
    "base16-framer",
    "base16-fruit-soda",
    "base16-gigavolt",
    "base16-google-dark",
    "base16-gotham",
    "base16-grayscale-dark",
    "base16-greenscreen",
    "base16-gruber",
    "base16-gruvbox-dark-hard",
    "base16-gruvbox-dark-medium",
    "base16-gruvbox-dark-pale",
    "base16-gruvbox-dark-soft",
    "base16-gruvbox-material-dark-hard",
    "base16-gruvbox-material-dark-medium",
    "base16-gruvbox-material-dark-soft",
    "base16-hardcore",
    "base16-harmonic-dark",
    "base16-harmonic16-dark",
    "base16-heetch",
    "base16-helios",
    "base16-hopscotch",
    "base16-horizon-dark",
    "base16-horizon-terminal-dark",
    "base16-humanoid-dark",
    "base16-ia-dark",
    "base16-icy",
    "base16-irblack",
    "base16-isotope",
    "base16-jabuti",
    "base16-kanagawa",
    "base16-katy",
    "base16-kimber",
    "base16-lime",
    "base16-macintosh",
    "base16-marrakesh",
    "base16-materia",
    "base16-material",
    "base16-material-darker",
    "base16-material-palenight",
    "base16-material-vivid",
    "base16-measured-dark",
    "base16-mellow-purple",
    "base16-mocha",
    "base16-monokai",
    "base16-mountain",
    "base16-nebula",
    "base16-nord",
    "base16-nova",
    "base16-ocean",
    "base16-oceanicnext",
    "base16-onedark",
    "base16-onedark-dark",
    "base16-outrun-dark",
    "base16-oxocarbon-dark",
    "base16-pandora",
    "base16-papercolor-dark",
    "base16-paraiso",
    "base16-pasque",
    "base16-phd",
    "base16-pico",
    "base16-pinky",
    "base16-pop",
    "base16-porple",
    "base16-precious-dark-eleven",
    "base16-precious-dark-fifteen",
    "base16-primer-dark",
    "base16-primer-dark-dimmed",
    "base16-purpledream",
    "base16-qualia",
    "base16-railscasts",
    "base16-rebecca",
    "base16-rose-pine",
    "base16-rose-pine-dawn",
    "base16-rose-pine-moon",
    "base16-saga",
    "base16-sandcastle",
    "base16-schemer-dark",
    "base16-schemer-medium",
    "base16-selenized-black",
    "base16-selenized-dark",
    "base16-seti",
    "base16-shades-of-purple",
    "base16-shadesmear-dark",
    "base16-shapeshifter",
    "base16-silk-dark",
    "base16-snazzy",
    "base16-solarflare",
    "base16-solarized-dark",
    "base16-spaceduck",
    "base16-spacemacs",
    "base16-sparky",
    "base16-standardized-dark",
    "base16-stella",
    "base16-still-alive",
    "base16-summercamp",
    "base16-summerfruit-dark",
    "base16-synth-midnight-dark",
    "base16-tango",
    "base16-tarot",
    "base16-tender",
    "base16-terracotta",
    "base16-terracotta-dark",
    "base16-tokyo-city-dark",
    "base16-tokyo-city-terminal-dark",
    "base16-tokyo-night-dark",
    "base16-tokyo-night-moon",
    "base16-tokyo-night-storm",
    "base16-tokyo-night-terminal-dark",
    "base16-tokyo-night-terminal-storm",
    "base16-tokyodark",
    "base16-tokyodark-terminal",
    "base16-tomorrow",
    "base16-tomorrow-night",
    "base16-tomorrow-night-eighties",
    "base16-tube",
    "base16-unikitty-dark",
    "base16-unikitty-reversible",
    "base16-uwunicorn",
    "base16-valua",
    "base16-vesper",
    "base16-vice",
    "base16-vulcan",
    "base16-windows-10",
    "base16-windows-95",
    "base16-windows-highcontrast",
    "base16-windows-nt",
    "base16-woodland",
    "base16-xcode-dusk",
    "base16-zenbones",
    "base16-zenburn",
  }
  local even_more_preferred_colorschemes = {
    "base16-tokyo-city-dark",
    "base16-tokyo-city-terminal-dark",
    "tokyonight",
    "tokyonight-storm",
    "tokyonight-moon",
    "tokyonight-night",
    "eldritch",
    "oxocarbon",
    "base16-oxocarbon-dark",
    "poimandres",
    "nightfox",
    -- "carbonfox",
    -- "duskfox",
    -- "nordfox",
    -- "terafox",
    "bluloco",
    "helix",
    "nord",
    "base16-nord",
    "base16-nova",
    "rose-pine",
    -- "rose-pine-moon",
    -- "rose-pine-main",
    "base16-rose-pine",
    "base16-rose-pine-moon",
    "base16-onedark",
    "base16-onedark-dark",
    "gruvbox",
    "base16-gruvbox-dark-hard",
    "base16-gruvbox-dark-pale",
    "base16-gruvbox-dark-soft",
    "ayu",
    "base16-ayu-dark",
    "base16-ayu-mirage",
    -- "ayu-dark",
    -- "ayu-mirage",
    "catppuccin-mocha",
    "catppuccin-macchiato",
    "catppuccin-frappe",
    "catppuccin",
    "base16-catppuccin",
    "base16-catppuccin-frappe",
    "base16-catppuccin-macchiato",
    "base16-catppuccin-mocha",
    "gruber-darker",
    "night-owl",
    "tokyodark",
    "tokyobones",
    "base16-tokyodark",
    "base16-tokyo-night-dark",
    "base16-tokyo-night-moon",
    "base16-tokyo-night-storm",
    "base16-tokyo-night-terminal-dark",
    "base16-tokyo-night-terminal-storm",
    "base16-tokyodark-terminal",
    "vague",
    "cold",
    "zenbones",
    -- "base16-zenbones",
    "base16-zenburn",
    -- "zenburned",
    -- "zenwritten",
  }

  local random_less_preferred = { less_preferred_colorschemes[math.random(#less_preferred_colorschemes)] }
  local all_less_colorschemes = vim.tbl_extend("force", random_less_preferred, more_preferred_colorschemes)
  local random_more_preferred = { all_less_colorschemes[math.random(#all_less_colorschemes)] }
  local all_colorschemes = vim.tbl_extend("force", random_more_preferred, even_more_preferred_colorschemes)
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
-- vim.api.nvim_create_autocmd('VeryLazy', {
-- pattern = '*',
-- callback = function()
local in_tmux = os.getenv("TMUX") ~= nil
-- local bg_color = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg")
if in_tmux then
  -- vim.fn.system("tmux set-option status-style bg=default")
  vim.fn.system(
    'tmux set status-right "#{#[bg=#{default_fg},bold]░}#[fg=${default_fg},bg=default] 󰃮 %Y-%m-%d 󱑒 %H:%M "'
  )
  -- vim.fn.system('if [ -n "$TMUX" ]; then tmux set-option status-style bg=' .. bg_color .. "; fi")
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
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = event.buf,
      -- group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = event.buf,
      -- group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      -- group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = "freshnvim-lsp-highlight", buffer = event2.buf })
      end,
    })
  end,
})
-- -- Create (or reuse) a namespace for our extmarks
-- local ns = vim.api.nvim_create_namespace("search_info_ns")
--
-- -- Function to clear any previous virtual text from our namespace
-- local function clear_search_info()
--   vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
-- end
--
-- -- Function to show search information as virtual text
-- local function show_search_info()
--   -- Clear previous extmarks so that we don't accumulate multiple messages
--   clear_search_info()
--
--   -- Get search count info; this returns a dictionary with keys like 'current' and 'total'
--   local count = vim.fn.searchcount({ recompute = 1 })
--   local current = count.current or 0
--   local total = count.total or 0
--
--   -- Format your message however you like.
--   local msg = string.format(" [%d/%d] ", current, total)
--
--   -- Find the current line (convert to 0-indexed)
--   local pos = vim.api.nvim_win_get_cursor(0)
--   local row = pos[1] - 1
--
--   -- Set virtual text on the current line at the end of the line ("eol")
--   vim.api.nvim_buf_set_extmark(0, ns, row, -1, {
--     virt_text = { { msg, "Search" } },
--     virt_text_pos = "eol", -- you can adjust this option (e.g., "overlay")
--     hl_mode = "combine",
--   })
-- end
--
-- -- Create an autocommand that triggers when you leave the search command line.
-- vim.api.nvim_create_autocmd("CmdlineLeave", {
--   pattern = { "/", "?" },
--   callback = function()
--     -- Use vim.schedule to ensure that the virtual text is set after the search has executed.
--     vim.schedule(function()
--       show_search_info()
--     end)
--   end,
-- })
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
-- vim.api.nvim_create_autocmd("VeryLazy", {
--   callback = function()
--     -- Your code here
--     vim.notify("VeryLazy")
--   end,
-- })
