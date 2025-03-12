local get_root = function()
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
  return cwd -- Ensure this is within the function's scope
end
return {

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
      -- get snacks
      "folke/snacks.nvim",
    },
    cmd = "Neotree",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = get_root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      -- -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- -- because `cwd` is not set up properly.
      -- vim.api.nvim_create_autocmd("BufEnter", {
      --   group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      --   desc = "Start Neo-tree with directory",
      --   once = true,
      --   callback = function()
      --     if package.loaded["neo-tree"] then
      --       return
      --     else
      --       local stats = vim.uv.fs_stat(vim.fn.argv(0))
      --       if stats and stats.type == "directory" then
      --         require("neo-tree")
      --       end
      --     end
      --   end,
      -- })
    end,
    opts = {
      -- filesystem = {
      --   filtered_items = {
      --     visible = false, -- when true, they will just be displayed differently than normal items
      --     hide_dotfiles = true,
      --     hide_gitignored = true,
      --     hide_hidden = true, -- only works on Windows for hidden files/directories
      --   },
      -- },
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        -- visible = true, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false, -- only works on Windows for hidden files/directories
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged = "󰱒",
          },
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
}
