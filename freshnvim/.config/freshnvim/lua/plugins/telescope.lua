local function determine_cwd()
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
    for _, client in pairs(vim.lsp.buf_get_clients()) do
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
return {
  {
    "nvim-telescope/telescope.nvim",--[[ tag = '0.1.8', ]]
    -- or                              , branch = '0.1.x',
    -- event = 'VeryLazy',
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-frecency.nvim" },
      -- If encountering errors, see telescope-fzf-native README for installation instructions
      {
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    cmd = {
      "Telescope",
      "Telescope find_files",
      "Telescope live_grep",
      "Telescope oldfiles",
      "Telescope grep_string",
      "Telescope help_tags",
      "Telescope buffers",
      "Telescope colorscheme",
      "Telescope diagnostics",
      "Telescope keymaps",
      "Telescope oldfiles",
      "Telescope resume",
      "Telescope current_buffer_fuzzy_find",
      "Telescope command_history",
      "Telescope git_files",
      "Telescope git_status",
      "Telescope git_commits",
      "Telescope frecency",
    },
    keys = {
      { "<leader>f:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "[S]earch [H]elp" },
      { "<leader>fk", "<cmd>lua require('telescope.builtin').keymaps()<cr>", desc = "[S]earch [K]eymaps" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[S]earch [F]iles" },
      { "<leader>fF", "<cmd>Telescope frecency<cr>", desc = "[S]earch [F]rencency" },
      { "<leader>fs", "<cmd>lua require('telescope.builtin').builtin()<cr>", desc = "[S]earch [S]elect Telescope" },
      { "<leader>fw", "<cmd>lua require('telescope.builtin').grep_string()<cr>", desc = "[S]earch current [W]ord" },
      { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "[S]earch by [G]rep" },
      -- git
      { "<leader>fgg", "<cmd>lua require('telescope.builtin').git_files()<cr>", desc = "Find Files (git-files)" },
      { "()<leader>fgs", "<cmd>Telescope git_status<CR>", desc = "Status" },
      { "<leader>fgc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>fd", "<cmd>lua require('telescope.builtin').diagnostics()<cr>", desc = "[S]earch [D]iagnostics" },
      { "<leader>fr", "<cmd>lua require('telescope.builtin').resume()<cr>", desc = "[S]earch [R]esume" },
      {
        "<leader>f.",
        "<cmd>lua require('telescope.builtin').oldfiles()<cr>",
        desc = '[S]earch Recent Files ("." for repeat)',
      },
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal theme=ivy<cr>", desc = "[ ] Find existing buffers" },
      { "<leader>col", "<cmd>lua require('telescope.builtin').colorscheme()<cr>", desc = "[S]earch all colorschemes" },
      { '<leader>f"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>fa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      -- Slightly advanced example of overriding default behavior and theme
      {
        "<leader>/",
        function()
          -- You can pass additional configuration to Telescope to change the theme, layout, etc.
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          }))
        end,
        desc = "[/] Fuzzily search in current buffer",
      },

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      {
        "<leader>fR",
        function()
          require("telescope").extensions.frecency.frecency({
            workspace = determine_cwd(),
            theme = "ivy",
          })
        end,
        desc = "Frecency in Current Workspace (Ivy Theme)",
      },
      {
        "<leader>f/",
        function()
          require("telescope.builtin").live_grep({
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          })
        end,
        desc = "[S]earch [/] in Open Files",
      },
      {
        "<leader>fgp",
        function()
          local cwd = determine_cwd()
          require("telescope.builtin").live_grep({ cwd = cwd })
        end,
        desc = "[S]earch by [G]rep based on cwd",
      },

      -- Shortcut for searching your Neovim configuration files
      {
        "<leader>con",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "[S]earch [N]eovim files",
      },
      -- Shortcut for searching your my current file or buffers root directory
      {
        "<leader><space>",
        function()
            -- cwd = vim.fn.getcwd()
            local cwd = determine_cwd()

          require("telescope.builtin").find_files({ cwd = cwd })
        end,
        desc = "[S]earch [N]eovim files",
      },
    },
    opts = {

      pickers = {
        colorscheme = {
          enable_preview = true,
        }, -- preview the colorscheme in the picker
        find_files = {
          hidden = true, -- enable this to see hidden files
        }, -- find files in the current directory
      },
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },
        mappings = {
            n = {
                ["d"] = require("telescope.actions").delete_buffer,
                -- ["e"] = require("telescope.actions").rename_buffer,
                -- ["<C-d>"] = require("telescope.actions").delete_buffer,
                -- ["<C-e>"] = require("telescope.actions").rename_buffer,
            },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
        ["frecency"] = {
          show_scores = true,
          show_filter_column = false,
          -- ignore_case = true,
          -- -- Only show the list of results when the search is finished
          -- -- and there are no more matches.
          -- only_show_scores = true,
          -- -- The maximum number of results to show.
          -- max_results = 25,
          -- -- The maximum number of results to show in the preview window.
          -- preview = 10,
          -- -- The maximum number of results to show in the quickfix window.
          -- qflist = 10,
          -- -- The maximum number of results to show in the prompt window.
          -- prompt = 10,
          -- -- The maximum number of results to show in the location list window.
          -- location = 10,
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
      pcall(require("telescope").load_extension, "frecency")
    end,
  },

  -- better vim.ui with telescope
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- Flash Telescope config
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local function flash(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<c-e>"] = flash } },
      })
    end,
  },
}
