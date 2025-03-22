local root = require("config.snacks_git")
-- Terminal Mappings
function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end
return {
  "snacks.nvim",
--   -- event = {"VeryLazy", "VimEnter"},
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    terminal = {
      win = {
        keys = {
          nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
          nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
          nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
          nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
        },
      },
    },
  },
  keys = function()
    local keys = {
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bo",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "Delete Other Buffers",
      },
      {
        "<leader>Ss",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
      {
        "<leader>dps",
        function()
          Snacks.profiler.scratch()
        end,
        desc = "Profiler Scratch Buffer",
      },
    }
    if vim.fn.executable("lazygit") == 1 then
      table.insert(keys, {
        "<leader>gg",
        function()
          Snacks.lazygit({ cwd = root.git() })
        end,
        desc = "Lazygit (Root Dir)",
      })
      table.insert(keys, {
        "<leader>gG",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit (cwd)",
      })
    end
    return keys
  end,
  -- config = function(_, opts)
  --   Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  --   Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  --   Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  --   Snacks.toggle.diagnostics():map("<leader>ud")
  --   Snacks.toggle.line_number():map("<leader>ul")
  --   Snacks.toggle
  --     .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
  --     :map("<leader>uc")
  --   Snacks.toggle
  --     .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
  --     :map("<leader>uA")
  --   Snacks.toggle.treesitter():map("<leader>uT")
  --   Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
  --   Snacks.toggle.dim():map("<leader>uD")
  --   Snacks.toggle.animate():map("<leader>ua")
  --   Snacks.toggle.indent():map("<leader>ug")
  --   Snacks.toggle.scroll():map("<leader>uS")
  --   Snacks.toggle.profiler():map("<leader>dpp")
  --   Snacks.toggle.profiler_highlights():map("<leader>dph")
  --   if vim.lsp.inlay_hint then
  --     Snacks.toggle.inlay_hints():map("<leader>uh")
  --   end
  -- end,
}
