-- detect if the os is wsl and if yes then, syncronize clipboard to it.
local function is_wsl()
    local osrelease_path = '/proc/sys/kernel/osrelease'
    local file = io.open(osrelease_path, 'r')
    if not file then
        return false
    end
    local osrelease = file:read('*a')
    file:close()
    return osrelease:lower():match('microsoft') ~= nil
end

if is_wsl() then
    -- print("Running on WSL")
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ['*'] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
    -- else
    -- 	print("Not running on WSL")
end


-- replace spaces with "•" in visual mode
function enable_list()
    vim.cmd('set listchars+=space:•')
    vim.cmd('set list')
end

function disable_list()
    vim.cmd('set listchars-=space:•')
    vim.cmd('set list')
end

-- Set up autocmd for mode changes
vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = '*', -- Apply to all file types (customize as needed)
    callback = function()
        local mode = vim.fn.mode()
        if mode == 'v' or mode == 'V' then
            enable_list()
        else
            disable_list()
        end
    end,
})

-- flash the text being highlighted
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('my-highlight-on-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

function rand_colorscheme()
    math.randomseed(os.time()) -- Set the random seed based on the current time

    local less_preferred_colorschemes = {
        'blue',
        'zaibatsu',
        'darkblue',
        'default',
        'delek',
        'desert',
        'elflord',
        'evening',
        'habamax',
        'industry',
        'koehler',
        'lunaperche',
        'morning',
        'murphy',
        'pablo',
        'peachpuff',
        'quiet',
        'retrobox',
        'ron',
        'shine',
        'slate',
        'sorbet',
        'torte',
        'vim',
        'wildcharm',
        'dayfox',
        'dawnfox',
        'rose-pine-dawn',
    }

    local more_preferred_colorschemes = {
        'poimandres',
        'nightfox',
        'nordfox',
        'terafox',
        'nord',
        'carbonfox',
        'duskfox',
        'rose-pine',
        'rose-pine-moon',
        'rose-pine-main',
        'gruvbox',
        'ayu',
        'ayu-dark',
        'ayu-mirage',
        'gruber_darker',
        'night-owl',
    }

    local random_less_preferred = {less_preferred_colorschemes[math.random(#less_preferred_colorschemes)],}
    local all_colorschemes = vim.tbl_extend('force', random_less_preferred, more_preferred_colorschemes)
    return all_colorschemes[math.random(#all_colorschemes)]
end
vim.cmd('colorscheme ' .. rand_colorscheme())

-- Create an augroup named "RestoreCursorPosition"
local group = vim.api.nvim_create_augroup('RestoreCursorPosition', { clear = true })
-- Define an autocommand within that group

vim.api.nvim_create_autocmd('BufReadPost', {
    group = group,
    pattern = '*',
    callback = function()
        local pos = vim.fn.line('\'"')
        if pos > 1 and pos <= vim.fn.line('$') then
            vim.api.nvim_command('normal! g`"')
        end
    end,
})

local delete_trailing_spaces_group = vim.api.nvim_create_augroup('delete_trailing_spaces_group', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
    group = delete_trailing_spaces_group,
    pattern = '*',
    -- callback = function()
    --     local pos = vim.fn.line('\'"')
    --     if pos > 1 and pos <= vim.fn.line('$') then
    --         vim.api.nvim_command('normal! g`"')
    --     end
    -- end,
    command = [[%s/\s\+$//e]],
})
local spell_check = vim.api.nvim_create_augroup('spellcheck', { clear = true })
vim.api.nvim_create_autocmd("fileType", {
    group = spell_check,
    pattern = {"markdown", "text", "env" },
    callback = function()
        -- vim.cmd("setlocal spelllang=en_us,nl,medical")
        vim.cmd("setlocal spell")
    end,
})
