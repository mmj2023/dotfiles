-- #keymaps#
--          --
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>")
vim.keymap.set({ "n", "v" }, "<leader>p", '"_dp')
vim.keymap.set("x", "<leader>p", '"_dp')

-- make statusline stay in the bottom when when working with splits
vim.keymap.set("x", "<leader>tt", "<cmd>set laststatus=3<CR>", {})

-- -- save text to clipboard
vim.keymap.set("n", "<leader>y", '"+y')

vim.keymap.set("v", "<leader>y", '"+y')

-- -- delete text in void
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- move highlighted text down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {})
-- move highlighted text up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {})

-- -- Move selected text left
-- vim.keymap.set('v', 'H', ":'<,'>d<Esc>:normal! hp<CR>")
-- -- Move selected text right
-- vim.keymap.set('v', 'L', ":'<,'>d<Esc>:normal! p<CR>")

-- keep selected text highlighted when indenting
vim.keymap.set("v", ">", ">gv", {})
vim.keymap.set("v", "<", "<gv", {})

vim.keymap.set("n", "<leader>pv", vim.cmd.Oil, {})
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>bp", "<cmd>bprev<CR>", { silent = true })
vim.keymap.set("n", "<leader><Tab>", ":b#<CR>", { silent = true })
-- -- disable netrw when oil.nvim is installed
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.keymap.set("n", "<C-Left>", ":vertical resize +2<CR>", { silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { silent = true })
-- toggle cursor column
function toggle_cursorcolumn()
  local cursorcolumn_enabled = vim.api.nvim_get_option_value("cursorcolumn", {})
  if cursorcolumn_enabled then
    vim.cmd("set nocursorcolumn")
  else
    vim.cmd("set cursorcolumn")
  end
end

vim.keymap.set("n", "<leader>cc", ":lua toggle_cursorcolumn()<cr>", { silent = true })

-- for toggling hlsearch
function toggle_hlsearch()
  local hlsearch_enabled = vim.api.nvim_get_option_value("hlsearch", {})
  if hlsearch_enabled then
    vim.cmd("set nohlsearch")
  else
    vim.cmd("set hlsearch")
  end
end

vim.keymap.set("n", "<leader>hl", "<cmd>lua toggle_hlsearch()<CR>", {})
vim.keymap.set("i", "<C-a>", "<C-o>", {})

function insert_comment_line()
  -- Get the current line number
  local current_line = vim.fn.line(".")
  -- print("Current line number:", current_line)
  -- Get the previous line number
  -- local previous_line = current_line - 1
  -- print("Previous line number:", previous_line)
  -- Check if previous line number is valid
  if current_line <= 0 then
    print("Invalid previous line number.")
    return
  end
  -- Get the text of the previous line
  local current_line_text = vim.fn.getline(current_line)
  -- print("Previous line text:", current_line_text)
  -- Calculate the length of the previous line
  local line_length = #current_line_text

  -- Debug print to check the line length
  -- print("Line length:", line_length)
  local comment_line = string.rep("-", line_length)
  vim.api.nvim_put({ comment_line }, "l", true, true)
  vim.cmd("normal! k")
  -- vim.cmd("normal! gcc")
  local config = require("Comment.config"):get()
  require("Comment.api").toggle.linewise.current(nil, config)
  vim.cmd("normal! ==") -- indent properly
  vim.cmd("normal! j")
end

vim.api.nvim_set_keymap("n", "<leader>com", ":lua insert_comment_line()<CR>", { noremap = true, silent = true })
