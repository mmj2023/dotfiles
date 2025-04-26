local root = require("config.snacks_git")
-- Terminal Mappings
local term_nav = function(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end
return {
  "snacks.nvim",
  event = {"VeryLazy"--[[ , "VimEnter" ]]},
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions.type == "move" then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end,
    })
  end,
  opts = {
    ---@class snacks.image
    ---@field terminal snacks.image.terminal
    ---@field image snacks.Image
    ---@field placement snacks.image.Placement
    ---@field util snacks.image.util
    ---@field buf snacks.image.buf
    ---@field doc snacks.image.doc
    ---@field convert snacks.image.convert
    ---@field inline snacks.image.inline
    images = {
      enabled = true,
      -- max_width = 100,
      -- max_height = 100,
      -- (Optional) A function to resolve image paths in markdown or another document.
      -- When nil, the image path is resolved relative to the current file.
      resolve = function(file, src)
        return vim.fn.fnamemodify(src, ":p")
      end,
    },
    bigfile = { enabled = true },
    notifier = {
        enabled = true,
        timeout = 1500,
    },
    quickfile = { enabled = true },
    zen = {
      -- your zen configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      enabled = true,
    },
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
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
      },
    }
    -- {"<leader>us",Snacks.toggle.option("spell", { name = "Spelling" }),desc = "toggle spell"},
    -- {"<leader>uw",Snacks.toggle.option("wrap", { name = "Wrap" }),desc = "toggle wrap"},
    -- {"<leader>uL",Snacks.toggle.option("relativenumber", { name = "Relative Number" }),desc = "toggle relativenumber"},
    -- {"<leader>ud",Snacks.toggle.diagnostics(),desc = "toggle diagnostics"},
    -- {"<leader>ul",Snacks.toggle.line_number(),desc = "toggle line number"},
    -- {"<leader>uc",Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }),desc = "toggle conceallevel"},
    -- {"<leader>uA",Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }),desc = "toggle tabline"},
    -- {"<leader>uT",Snacks.toggle.treesitter(),desc = "toggle treesitter"},
    -- {"<leader>ub",Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }),desc = "toggle background"},
    -- {"<leader>uD",Snacks.toggle.dim(),desc = "toggle dim"},
    -- {"<leader>ua",Snacks.toggle.animate(),desc = "toggle animate"},
    -- {"<leader>ug",Snacks.toggle.indent(),desc = "toggle indent"},
    -- {"<leader>uS",Snacks.toggle.scroll(),desc = "toggle scroll"},
    -- {"<leader>dpp",Snacks.toggle.profiler(),desc = "toggle profiler"},
    -- {"<leader>dph",Snacks.toggle.profiler_highlights(),desc = "toggle profiler highlights"}
    -- if vim.lsp.inlay_hint then
    --   table.insert(keys, {
    --       "<leader>uh",
    --       function()
    --   Snacks.toggle.inlay_hints()
    --   end,
    --   desc = "Toggle Inlay Hints",
    --   })
    -- end
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
  config = function(_, opts)
      require("snacks").setup(opts)
    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.line_number():map("<leader>ul")
    Snacks.toggle
      .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
      :map("<leader>uc")
    Snacks.toggle
      .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
      :map("<leader>uA")
    Snacks.toggle.treesitter():map("<leader>uT")
    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
    Snacks.toggle.dim():map("<leader>uD")
    Snacks.toggle.animate():map("<leader>ua")
    Snacks.toggle.indent():map("<leader>ug")
    Snacks.toggle.scroll():map("<leader>uS")
    Snacks.toggle.profiler():map("<leader>dpp")
    Snacks.toggle.profiler_highlights():map("<leader>dph")
    if vim.lsp.inlay_hint then
      Snacks.toggle.inlay_hints():map("<leader>uh")
    end
  end,
}
