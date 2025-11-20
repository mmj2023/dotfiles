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

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- -- delete text in void
vim.keymap.set("n", "<leader>d", '"_d', {desc = "delete text in void"})
vim.keymap.set("v", "<leader>d", '"_d', {desc = "delete text in void"})

-- move highlighted text down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "move highlighted text down"})
-- move highlighted text up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "move highlighted text up"})

-- -- Move selected text left
-- vim.keymap.set('v', 'H', ":'<,'>d<Esc>:normal! hp<CR>")
-- -- Move selected text right
-- vim.keymap.set('v', 'L', ":'<,'>d<Esc>:normal! p<CR>")

-- keep selected text highlighted when indenting
vim.keymap.set("v", ">", ">gv", {desc = "indent selected text and keep it highlighted"})
vim.keymap.set("v", "<", "<gv", {desc = "unindent selected text and keep it highlighted"})

vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { silent = true, desc = "change with next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprev<CR>", { silent = true, desc = "change with previous buffer" })
-- vim.keymap.set("n", "<leader><Tab>", ":b#<CR>", { silent = true })
vim.keymap.set("n", "<leader><Tab>", "<C-6>", { silent = true, desc = "change with previous buffer" })

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

vim.keymap.set("n", "<leader>cc", ":lua toggle_cursorcolumn()<cr>", { silent = true, desc = "Toggle Cursor Column" })

-- for toggling hlsearch
function toggle_hlsearch()
  local hlsearch_enabled = vim.api.nvim_get_option_value("hlsearch", {})
  if hlsearch_enabled then
    vim.cmd("set nohlsearch")
  else
    vim.cmd("set hlsearch")
  end
end

vim.keymap.set("n", "<leader>hl", "<cmd>lua toggle_hlsearch()<CR>", { silent = true, desc = "Toggle HLSearch" })
vim.keymap.set("i", "<C-a>", "<C-o>", {})
-- vim.keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })
-- lazy
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

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
-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
-- vim.keymap.set("n", "/", function()
--   -- Use a custom prompt icon, e.g., "🔍 " instead of "/"
--   local query = vim.fn.input("🔍󰄼 ") -- 
--   -- If the user entered a query, start searching
--   if query and query ~= "" then
--     -- Start search in the forward direction using the input
--     vim.cmd("normal! /" .. query .. "\n")
--   end
--   -- Return empty string to prevent the default behavior
--   return ""
-- end, { noremap = true, silent = true, expr = false })
-- vim.keymap.set("n", "?", function()
--   -- Use a custom prompt icon, for example "❓ " instead of "?"
--   local query = vim.fn.input("🔍󰄿 ") -- ❓
--   if query and query ~= "" then
--     -- Start a backward search using the input
--     vim.cmd("normal! ?" .. query .. "\n")
--   end
--   return ""
-- end, { noremap = true, silent = true, expr = false })

