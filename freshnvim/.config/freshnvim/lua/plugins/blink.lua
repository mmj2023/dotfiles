local trigger_text = ";"
return {
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    enabled = false,
  },
  {
    "Kaiser-Yang/blink-cmp-avante",
  },
  {
    "saghen/blink.cmp",
    enabled = true,
    event = { "InsertEnter", "CmdlineEnter" },
    build = "cargo clean; cargo build --release",
    -- In case there are breaking changes and you want to go back to the last
    -- working release
    -- https://github.com/Saghen/blink.cmp/releases
    -- version = "v0.13.1",
    version = "*",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },

    dependencies = {
      "moyiz/blink-emoji.nvim",
      "Kaiser-Yang/blink-cmp-dictionary",
      {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = { "kristijanhusak/vim-dadbod-ui", "tpope/vim-dadbod" },
      },
      { "L3MON4D3/LuaSnip", lazy = true }, -- Make sure LuaSnip is installed
      { "rafamadriz/friendly-snippets", lazy = true },
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = function(_, opts)
      require("luasnip.loaders.from_vscode").lazy_load()
      -- I noticed that telescope was extremeley slow and taking too long to open,
      -- assumed related to blink, so disabled blink and in fact it was related
      -- :lua print(vim.bo[0].filetype)
      -- So I'm disabling blink.cmp for Telescope
      opts.enabled = function()
        -- Get the current buffer's filetype
        local filetype = vim.bo[0].filetype
        -- Disable for Telescope buffers
        if filetype == "TelescopePrompt" or filetype == "minifiles" or filetype == "snacks_picker_input" then
          return false
        end
        return true
      end
      -- NOTE: The new way to enable LuaSnip
      -- Merge custom sources with the existing ones from lazyvim
      -- NOTE: by default lazyvim already includes the lazydev source, so not adding it here again
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
        default = { "lsp", "path", "snippets", "buffer", "dadbod", "emoji", "dictionary" },
        providers = {
          lsp = {
            name = "lsp",
            enabled = true,
            module = "blink.cmp.sources.lsp",
            -- kind = "LSP",
            min_keyword_length = 2,
            -- When linking markdown notes, I would get snippets and text in the
            -- suggestions, I want those to show only if there are no LSP
            -- suggestions
            --
            -- Enabled fallbacks as this seems to be working now
            -- Disabling fallbacks as my snippets wouldn't show up when editing
            -- lua files
            -- fallbacks = { "snippets", "buffer" },
            score_offset = 90, -- the higher the number, the higher the priority
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 25,
            -- When typing a path, I would get snippets and text in the
            -- suggestions, I want those to show only if there are no path
            -- suggestions
            fallbacks = { "snippets", "buffer" },
            -- min_keyword_length = 2,
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },
          buffer = {
            name = "Buffer",
            enabled = true,
            max_items = 3,
            module = "blink.cmp.sources.buffer",
            min_keyword_length = 4,
            score_offset = 15, -- the higher the number, the higher the priority
          },
          snippets = {
            enabled = true,
            name = "snippets",
            -- expand = function(snippet)
            --   require("luasnip").lsp_expand(snippet)
            -- end,
            -- active = function(filter)
            --     if filter and filter.direction then
            --         return require("luasnip").jumpable(filter.direction)
            --     end
            --     return require("luasnip").in_snippet()
            -- end,
            -- jump = function(direction)
            --     return require("luasnip").jump(direction)
            -- end,
            max_items = 15,
            min_keyword_length = 2,
            module = "blink.cmp.sources.snippets",
            score_offset = 85, -- the higher the number, the higher the priority
            -- Only show snippets if I type the trigger_text characters, so
            -- to expand the "bash" snippet, if the trigger_text is ";" I have to
            should_show_items = function()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
              -- NOTE: remember that `trigger_text` is modified at the top of the file
              return before_cursor:match(trigger_text .. "%w*$") ~= nil
            end,
            -- After accepting the completion, delete the trigger_text characters
            -- from the final inserted text
            -- Modified transform_items function based on suggestion by `synic` so
            -- that the luasnip source is not reloaded after each transformation
            -- https://github.com/linkarzu/dotfiles-latest/discussions/7#discussion-7849902
            -- NOTE: I also tried to add the ";" prefix to all of the snippets loaded from
            -- friendly-snippets in the luasnip.lua file, but I was unable to do
            -- so, so I still have to use the transform_items here
            -- This removes the ";" only for the friendly-snippets snippets
            transform_items = function(_, items)
              local line = vim.api.nvim_get_current_line()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before_cursor = line:sub(1, col)
              local start_pos, end_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
              if start_pos then
                for _, item in ipairs(items) do
                  if not item.trigger_text_modified then
                    ---@diagnostic disable-next-line: inject-field
                    item.trigger_text_modified = true
                    item.textEdit = {
                      newText = item.insertText or item.label,
                      range = {
                        start = { line = vim.fn.line(".") - 1, character = start_pos - 1 },
                        ["end"] = { line = vim.fn.line(".") - 1, character = end_pos },
                      },
                    }
                  end
                end
              end
              return items
            end,
          },
          -- Example on how to configure dadbod found in the main repo
          -- https://github.com/kristijanhusak/vim-dadbod-completion
          dadbod = {
            name = "Dadbod",
            module = "vim_dadbod_completion.blink",
            min_keyword_length = 2,
            score_offset = 85, -- the higher the number, the higher the priority
          },
          -- https://github.com/moyiz/blink-emoji.nvim
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 93, -- the higher the number, the higher the priority
            min_keyword_length = 2,
            opts = { insert = true }, -- Insert emoji (default) or complete its name
          },
          -- https://github.com/Kaiser-Yang/blink-cmp-dictionary
          -- In macOS to get started with a dictionary:
          -- cp /usr/share/dict/words ~/github/dotfiles-latest/dictionaries/words.txt
          --
          -- NOTE: For the word definitions make sure "wn" is installed
          -- brew install wordnet
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            score_offset = 20, -- the higher the number, the higher the priority
            -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
            enabled = true,
            max_items = 8,
            min_keyword_length = 3,
            opts = {
              -- -- The dictionary by default now uses fzf, make sure to have it
              -- -- installed
              -- -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
              --
              -- Do not specify a file, just the path, and in the path you need to
              -- have your .txt files
              dictionary_directories = { vim.fn.expand("~/github/dotfiles-latest/dictionaries") },
              -- Notice I'm also adding the words I add to the spell dictionary
              dictionary_files = {
                vim.fn.expand("~/dotfiles/freshnvim/spell/en.utf-8.add"),
                vim.fn.expand("~/dotfiles/freshnvim/spell/es.utf-8.add"),
                -- vim.fn.expand("~/github/dotfiles-latest/neovim/neobean/spell/es.utf-8.add"),
              },
              -- --  NOTE: To disable the definitions uncomment this section below
              --
              -- separate_output = function(output)
              --   local items = {}
              --   for line in output:gmatch("[^\r\n]+") do
              --     table.insert(items, {
              --       label = line,
              --       insert_text = line,
              --       documentation = nil,
              --     })
              --   end
              --   return items
              -- end,
            },
          },
          -- -- Third class citizen mf always talking shit
          -- copilot = {
          --   name = "copilot",
          --   enabled = true,
          --   module = "blink-cmp-copilot",
          --   kind = "Copilot",
          --   min_keyword_length = 6,
          --   score_offset = -100, -- the higher the number, the higher the priority
          --   async = true,
          -- },
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {
              -- options for blink-cmp-avante
            },
          },
        },
      })

      opts.cmdline = {
        enabled = true,
      }

      opts.completion = {
        accept = {
          auto_brackets = {
            enabled = true,
            default_brackets = { ";", "" },
            override_brackets_for_filetypes = {
              markdown = { ";", "" },
            },
          },
        },
        --   keyword = {
        --     -- 'prefix' will fuzzy match on the text before the cursor
        --     -- 'full' will fuzzy match on the text before *and* after the cursor
        --     -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
        --     range = "full",
        --   },
        menu = {
          border = "single",
          draw = {
            treesitter = { "lsp" },
            components = {
              -- kind_icon = {
              --   text = function(ctx)
              --     local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
              --     return kind_icon
              --   end,
              --   -- (optional) use highlights from mini.icons
              --   highlight = function(ctx)
              --     local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              --     return hl
              --   end,
              -- },
              -- kind = {
              --   -- (optional) use highlights from mini.icons
              --   highlight = function(ctx)
              --     local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              --     return hl
              --   end,
              -- },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "single",
          },
        },
        -- Displays a preview of the selected item on the current line
        ghost_text = {
          enabled = true,
        },
      }
      -- opts.fuzzy = {
      --   -- Disabling this matches the behavior of fzf
      --   use_typo_resistance = false,
      --   -- Frecency tracks the most recently/frequently used items and boosts the score of the item
      --   use_frecency = true,
      --   -- Proximity bonus boosts the score of items matching nearby words
      --   use_proximity = false,
      -- }

      opts.snippets = {
        preset = "luasnip", -- Choose LuaSnip as the snippet engine
      }
      opts.appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      }
      -- -- To specify the options for snippets
      -- opts.sources.providers.snippets.opts = {
      --   use_show_condition = true, -- Enable filtering of snippets dynamically
      --   show_autosnippets = true, -- Display autosnippets in the completion menu
      -- }

      -- The default preset used by lazyvim accepts completions with enter
      -- I don't like using enter because if on markdown and typing
      -- something, but you want to go to the line below, if you press enter,
      -- the completion will be accepted
      -- https://cmp.saghen.dev/configuration/keymap.html#default
      opts.keymap = {
        preset = "none",
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        -- ["<C-p>"] = { "snippet_forward", "fallback" },
        -- ["<C-n>"] = { "snippet_backward", "fallback" },
        ["<C-y>"] = { "select_and_accept" },

        -- ["<Up>"] = { "select_prev", "fallback" },
        -- ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },

        ["<S-k>"] = { "scroll_documentation_up", "fallback" },
        ["<S-j>"] = { "scroll_documentation_down", "fallback" },

        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
      }
      local enable = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enable) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enable, source)
        end
      end
      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil
      -- print(vim.inspect(opts.sources.providers))
      -- print(vim.inspect(enable))
      local icons = {
        misc = {
          dots = "󰇘",
        },
        ft = {
          octo = "",
        },
        dap = {
          Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
          Breakpoint = " ",
          BreakpointCondition = " ",
          BreakpointRejected = { " ", "DiagnosticError" },
          LogPoint = ".>",
        },
        diagnostics = {
          Error = " ",
          Warn = " ",

          Hint = " ",

          Info = " ",
        },
        git = {
          added = " ",
          modified = " ",
          removed = " ",
          changedelete = "󱕖 ",
        },
        kinds = {
          Array = " ",

          Boolean = "󰨙 ",
          Class = " ",
          Codeium = "󰘦 ",
          Color = " ",
          Control = " ",
          Collapsed = " ",
          Constant = "󰏿 ",
          Constructor = " ",
          Copilot = " ",
          Enum = " ",
          EnumMember = " ",
          Event = " ",
          Field = " ",
          File = " ",
          Folder = " ",
          Function = "󰊕 ",
          Interface = " ",
          Key = " ",
          Keyword = " ",

          Method = "󰊕 ",
          Module = " ",
          Namespace = "󰦮 ",
          Null = " ",
          Number = "󰎠 ",

          Object = " ",

          Operator = " ",
          Package = " ",
          Property = " ",
          Reference = " ",
          Snippet = " ",
          String = " ",
          Struct = "󰆼 ",

          TabNine = "󰏚 ",
          Text = " ",
          TypeParameter = " ",
          Unit = " ",

          Value = " ",

          Variable = "󰀫 ",
        },
      }

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
              item.kind_icon = icons.kinds[item.kind_name] or item.kind_icon or nil
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end
      return opts
    end,
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    -- config = function(_, opts)
    --   -- setup compat sources
    --   require("blink.cmp").setup(opts)
    --
    -- end,
  },
  -- add icons
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      local icons = {
        misc = {
          dots = "󰇘",
        },
        ft = {
          octo = "",
        },
        dap = {
          Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
          Breakpoint = " ",
          BreakpointCondition = " ",
          BreakpointRejected = { " ", "DiagnosticError" },
          LogPoint = ".>",
        },
        diagnostics = {
          Error = " ",
          Warn = " ",

          Hint = " ",

          Info = " ",
        },
        git = {
          added = " ",
          modified = " ",
          removed = " ",
          changedelete = "󱕖 ",
        },
        kinds = {
          Array = " ",

          Boolean = "󰨙 ",
          Class = " ",
          Codeium = "󰘦 ",
          Color = " ",
          Control = " ",
          Collapsed = " ",
          Constant = "󰏿 ",
          Constructor = " ",
          Copilot = " ",
          Enum = " ",
          EnumMember = " ",
          Event = " ",
          Field = " ",
          File = " ",
          Folder = " ",
          Function = "󰊕 ",
          Interface = " ",
          Key = " ",
          Keyword = " ",

          Method = "󰊕 ",
          Module = " ",
          Namespace = "󰦮 ",
          Null = " ",
          Number = "󰎠 ",

          Object = " ",

          Operator = " ",
          Package = " ",
          Property = " ",
          Reference = " ",
          Snippet = " ",
          String = " ",
          Struct = "󰆼 ",

          TabNine = "󰏚 ",
          Text = " ",
          TypeParameter = " ",
          Unit = " ",

          Value = " ",

          Variable = "󰀫 ",
        },
      }
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, icons.kinds)
    end,
  },
  -- lazydev
  -- {
  --   "saghen/blink.cmp",
  --   opts = {
  --     sources = {
  --       -- add lazydev to your completion providers
  --       default = { "lazydev" },
  --       providers = {
  --         lazydev = {
  --           name = "LazyDev",
  --           module = "lazydev.integrations.blink",
  --           score_offset = 100, -- show at a higher priority than lsp
  --         },
  --       },
  --     },
  --   },
  -- },
}
