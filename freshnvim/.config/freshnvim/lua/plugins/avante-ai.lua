return {
  "yetone/avante.nvim",
  -- event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  cmd = { "Avante" },
  keys = {
    { "<leader>aa", "<cmd>Avante<cr>", desc = "Avante" },
    { "<leader>aC", "<cmd>Avanteclose<cr>", desc = "Avante (close tab)" },
    { "<leader>aA", "<cmd>Avante<cr>", desc = "Avante (with autocompletion)" },
    { "<leader>aR", "<cmd>AvanteReplace<cr>", desc = "Avante (replace mode)" },
    { "<leader>aS", "<cmd>AvanteReplace<cr>", desc = "Avante (replace mode)" },
  },
  opts = {
    -- add any opts here
    -- for example
    -- provider = "openai",
    -- openai = {
    --   endpoint = "https://api.openai.com/v1",
    --   model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
    --   timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
    --   temperature = 0,
    --   max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    --   --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    -- },
    provider = "gemini",
    gemini = {
      -- @see https://ai.google.dev/gemini-api/docs/models/gemini
      -- model = "gemini-2.0-flash", -- your desired model (or use gpt-4o, etc.)
      -- model = "gemini-2.5-pro-preview-06-05", -- your desired model (or use gpt-4o, etc.)
      model = "gemini-2.5-flash-preview-05-20", -- your desired model (or use gpt-4o, etc.)
      timeout = 30000, -- timeout in milliseconds
      temperature = 0, -- adjust if needed
      max_tokens = 4096,
    },
    vendors = {
      groq = {
        __inherited_from = "openai",
        -- model = "grok-3-mini-fast-0404",
        -- model = "grok-2-latest",
        model = "llama-3.1-70b-versatile",
        endpoint = "https://api.x.ai/v1/chat/completions", -- your Grok API endpoint
        -- endpoint = "https://api.groq.com/openai/v1/",
        api_key_name = "GROQ_API_KEY", --[[ or "YOUR_GROK_API_KEY", -- place your API key here, ]]
        timeout = 30000, -- optional timeout in milliseconds
        temperature = 0, -- additional Grok settings if supported
        max_tokens = 8192,
        max_completion_tokens = 8192,
        model = "grok-3-mini-fast-latest",
        stream = false, -- optional, defaults to false
      },
    },
    -- behaviour = {
    -- auto_suggestions = false, -- Experimental stage
    -- auto_set_highlight_group = true,
    -- auto_set_keymaps = true,
    -- auto_apply_diff_after_generation = false,
    -- support_paste_from_clipboard = false,
    -- },
    file_selector = {
      --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string | fun(params: avante.file_selector.IParams|nil): nil
      provider = "telescope",
      -- Options override for custom providers
      provider_opts = {},
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "MeanderingProgrammer/render-markdown.nvim",
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "echasnovski/mini.icons",
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
  },
}
