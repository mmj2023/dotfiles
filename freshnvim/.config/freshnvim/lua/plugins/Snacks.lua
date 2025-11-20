local determine_cwd = function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local cwd = vim.fn.expand("%:p:h")

  -- Check for specific file explorer buffers
  if vim.bo.filetype == "netrw" then
    cwd = vim.fn.expand("%:p:h")
  elseif vim.bo.filetype == "oil" then
    cwd = require("oil").get_current_dir()
  elseif vim.bo.filetype == "neo-tree" then
    cwd = require("neo-tree").get_current_node().path
  elseif vim.bo.filetype == "NvimTree" then
    cwd = require("nvim-tree.lib").get_node_at_cursor().absolute_path
  elseif vim.bo.filetype == "minifiles" then
    cwd = require("minifiles").get_current_dir()
  else
    -- Check if LSP is attached and get the root directory
    for _, client in pairs(vim.lsp.get_clients()) do
      if client.config.root_dir then
        local lsp_root_dir = client.config.root_dir
        if bufname:find(lsp_root_dir, 1, true) then
          cwd = lsp_root_dir
          break
        end
      end
    end
  end

  return cwd
end
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
  -- lazy = false,
  event = {
    "VeryLazy",
    -- "VimEnter",
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions.type == "move" then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end,
    })
    vim.api.nvim_create_autocmd("VimEnter", {
     callback = function(data)
      if vim.fn.isdirectory(data.file) == 1 then
          local cwd = determine_cwd()
          Snacks.explorer({ cwd = cwd })
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
    selected = {
      show_always = true, -- only show the selected column when there are multiple selections
      unselected = false, -- use the unselected icon for unselected items
    },
    images = {
      enabled = true,
      force = true, -- try displaying the image, even if the terminal does not support it
      -- max_width = 100,
      -- max_height = 100,
      -- (Optional) A function to resolve image paths in markdown or another document.
      -- When nil, the image path is resolved relative to the current file.
      -- resolve = function(file, src)
      --   return vim.fn.fnamemodify(src, ":p")
      -- end,
      doc = {
        -- enable image viewer for documents
        -- a treesitter parser must be available for the enabled languages.
        enabled = true,
        -- render the image inline in the buffer
        -- if your env doesn't support unicode placeholders, this will be disabled
        -- takes precedence over `opts.float` on supported terminals
        inline = true,
        -- render the image in a floating window
        -- only used if `opts.inline` is disabled
        float = true,
        max_width = 80,
        max_height = 40,
        -- Set to `true`, to conceal the image text when rendering inline.
        -- (experimental)
        ---@param lang string tree-sitter language
        ---@param type snacks.image.Type image type
        conceal = function(lang, type)
          -- only conceal math expressions
          return type == "math"
        end,
      },
    },
    bigfile = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 1500,
    },
    quickfile = { enabled = true },
    explorer = {
      -- your explorer configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      enabled = true,
      layout = { preset = "sidebar", preview = true },
      replace_netrw = true,

    },
    picker = {
      enabled = true,
      prompt = "  ",
      sources = {
        explorer = {
          -- your explorer picker configuration comes here
          -- or leave it empty to use the default settings
        },
      },
      ---@class snacks.picker.matcher.Config
      matcher = {
        frecency = true, -- frecency bonus
      },
      debug = {
        scores = true, -- show scores for each source
      },
    },
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
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
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
      -- alternative exists in telescope plugin config
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "[S]earch [N]eovim files in a smart manner",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.lines({
            layout = {
              preview = false,
              preset = "vscode",
            },
          })
        end,
        desc = "[/] Fuzzily search in current buffer",
      },
      {
        "<leader>fgp",
        function()
          local cwd = determine_cwd()
          Snacks.picker.grep({ cwd = cwd, prompt = "   " })
        end,
        desc = "[S]earch by [G]rep based on cwd",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      -- find
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers({
            win = {
              input = {
                keys = {
                  ["dd"] = "bufdelete",
                  ["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
                },
              },
              list = { keys = { ["dd"] = "bufdelete" } },
            },
            layout = "ivy",
            hidden = false,
            current = true,
            sort_lastused = true,
            on_show = function()
              vim.cmd.stopinsert()
            end,
          })
        end,
        desc = "[ ] Find existing buffers",
      },
      {
        "<leader>fk",
        function()
          Snacks.picker.keymaps({
            layout = "vertical",
          })
        end,
        desc = "[S]earch [K]eymaps",
      },
      -- {
      --   "<leader>col",
      --   function()
      --     Snacks.picker.colorschemes()
      --   end,
      --   desc = "[S]earch all colorschemes",
      -- },
      {
        "<leader>fh",
        function()
          Snacks.picker.help()
        end,
        desc = "[S]earch [H]elp",
      },
      {
        "<leader>con",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "[S]earch [N]eovim files",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "[S]earch [F]iles",
      },
      {
        "<leader>fgg",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Files (git-files)",
      },
      -- {
      --   "<leader>fp",
      --   function()
      --     Snacks.picker.projects()
      --   end,
      --   desc = "Projects",
      -- },
      {
        "<leader>f.",
        function()
          Snacks.picker.recent()
        end,
        desc = '[S]earch Recent Files ("." for repeat)',
      },
      ------------------------------------------------------------------------------
      -- LSP
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Goto Definition",
      },
      {
        "gD",
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = "Goto Declaration",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = "References",
      },
      {
        "gI",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Goto Implementation",
      },
      {
        "gy",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Goto T[y]pe Definition",
      },
      -- New explorer
      {
        "<leader>fp",
        function()
          local cwd = determine_cwd()
          Snacks.explorer({ cwd = cwd })
        end,
        desc = "Explorer Snacks (cwd)",
      },
      {
        "<leader>foe",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer Snacks",
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
      {
        "<leader>Z",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Toggle Zoom",
      },
      {
        "<leader>I",
        function()
          Snacks.image.hover()
        end,
        desc = "Toggle Zoom",
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
