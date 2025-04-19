return {
  { "oneslash/helix-nvim", lazy = false, priority = 1000 },
  { "gmr458/cold.nvim", lazy = false, priority = 1000 },
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    -- you can set set configuration options here
    -- config = function()
    --     vim.g.zenbones_darken_comments = 45
    --     vim.cmd.colorscheme('zenbones')
    -- end
  },
  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    opts = {},
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    -- opts = {},
  },
  {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        module_default = false,
        modules = {
          aerial = true,
          cmp = true,
          ["dap-ui"] = true,
          dashboard = true,
          diagnostic = true,
          gitsigns = true,
          native_lsp = true,
          neotree = true,
          notify = true,
          symbol_outline = true,
          telescope = true,
          treesitter = true,
          whichkey = true,
        },
      },
      groups = { all = { NormalFloat = { link = "Normal" } } },
    },
  },
  {
    "oxfist/night-owl.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      require("night-owl").setup()
    end,
  },
  {
    "olivercederborg/poimandres.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("poimandres").setup({
        -- leave this setup function empty for default config
        -- or refer to the configuration section
        -- for configuration options
        -- vim.cmd("colorscheme poimandres")
      })
    end,

    -- optionally set the colorscheme within lazy config
    -- init = function()
    -- vim.cmd("colorscheme poimandres")
    -- end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      -- vim.cmd("colorscheme rose-pine")
    end,
  },
  {
    "Shatur/neovim-ayu",
    priority = 1000,
    config = true,
    -- opts = {},
    config = function()
      require("ayu").setup({
        mirage = false, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
        terminal = true, -- Set to `false` to let terminal manage its own colors.
        overrides = {}, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
      })
    end,
  },
  -- {
  --   "hwadii/gruber_darker.nvim",
  --   dependencies = {
  --     "rktjmp/lush.nvim", -- this theme depends on lush.nvim
  --   },
  --   priority = 1000,
  --   -- config = true,
  --   -- opts = {},
  -- },
  { "blazkowolf/gruber-darker.nvim" },
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nord").setup({})
      -- vim.cmd.colorscheme("nord")
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
    opts = {},
  },
  {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    -- dev = true,
    priority = 1000,
    opts = {
      transparent_background = false,
      custom_highlights = function(hl, p)
        return {
          ["LspInlayHint"] = { bg = "#1C1C2A", fg = "#9AA0A7" },
          -- ["Conceal"] = { bg = "NONE" },
          ["@module"] = { link = "TSType" },
          ["@property"] = { link = "Identifier" },
          ["@variable"] = { fg = "#Afa8ea" },
          ["@lsp.type.variable"] = { fg = "#Afa8ea" },
          ["@module.latex"] = { link = "Red" },
          ["@markup.link.latex"] = { link = "Blue" },
          ["CmpItemKindCopilot"] = { fg = "#6CC644" },
          NoiceLspProgressSpinner = { bg = "#1C1C2A" },
          NoiceLspProgressClient = { bg = "#1C1C2A" },
          NoiceLspProgressTitle = { bg = "#1C1C2A" },
          NoiceMini = { bg = "#1C1C2A" },
          NoiceCmdlineIconSearch = { link = "Blue" },
        }
      end,
    },
    config = function(_, opts)
      require("tokyodark").setup(opts)
      -- require("tokyodark").colorscheme()
    end,
  },
  {
    "vague2k/vague.nvim",
    config = function()
      -- NOTE: you do not need to call setup if you don't want to.
      require("vague").setup({
        -- optional configuration here
      })
    end,
  },
  {
    "RRethy/base16-nvim",
  },
  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
          end
        end,
      },
    },
  },
}
