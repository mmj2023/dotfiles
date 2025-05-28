return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "FreshFile",
    dependencies = {
      "williamboman/mason.nvim",
      { "williamboman/mason-lspconfig.nvim", config = function() end },
      "snacks.nvim",
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue", "markdown", "txt" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- format = {
        --   formatting_options = nil,
        --   timeout_ms = nil,
        -- },
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          -- Lua LS configuration
          lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
            -- keys = {},
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
          -- JDTLS (Java language server) configuration with many features enabled
          jdtls = {
            root_markers = { ".git", "pom.xml", "build.gradle" },
            settings = {
              java = {
                signatureHelp = { enabled = true },
                contentProvider = { preferred = "fernflower" }, -- Use Fernflower for enhanced code decompiling
                codeGeneration = {
                  generateComments = true, -- Generate Javadoc style comments automatically
                  useBlocks = true, -- Wrap code generation in code blocks where applicable
                },
                completion = {
                  favoriteStaticMembers = {
                    "org.junit.Assert",
                    "org.mockito.Mockito",
                  },
                },
                referencesCodeLens = { enabled = true }, -- Show references as CodeLens
                implementationsCodeLens = { enabled = true }, -- Show implementations as CodeLens
                inlayHints = { enabled = true }, -- Inlay hints for parameter names etc.
                format = { enabled = true }, -- Enable formatting
                configuration = {
                  updateBuildConfiguration = "interactive", -- Auto-update project configuration when required
                },
              },
            },
            init_options = {
              bundles = {}, -- Here you might add Java debugger bundles, if desired.
            },
          },
          -- OCaml LSP configuration with inlay hints, formatting, diagnostics, and completion fully enabled.
          ocamllsp = {
            root_markers = { "dune-project", "dune-workspace" },
            settings = {
              ocaml = {
                inlayHints = { enabled = true },
                diagnostics = { enabled = true },
                format = { enabled = true },
                completion = { enabled = true },
                -- Add other ocaml-specific settings here as needed.
              },
            },
          },
          -- intelephense = {
          --   settings = {
          --     intelephense = {
          --       files = {
          --         maxSize = 5000000, -- Set file size limit
          --       },
          --     },
          --   },
          -- },
          -- Clangd (C/C++ language server) configuration with full features enabled.
          clangd = {
            -- Adjust the 'cmd' options as needed for your environment.
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--completion-style=detailed",
              "--header-insertion=iwyu",
            },
            settings = {
              clangd = {
                semanticHighlighting = true, -- Dynamic semantic colors for enhanced code readability.
                inlayHints = { enabled = true },
                codeLens = { enabled = true },
              },
            },
            init_options = {
              clangdFileStatus = true, -- Provides clangd with file status feedback.
              usePlaceholders = true, -- Enables placeholders in completion items.
              completeUnimported = true, -- Automatically complete symbols from unimported headers.
              semanticHighlighting = true,
              codeLens = { enabled = true },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
      return ret
    end,
    keys = function()
      local key = {}
      return key
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Define your keymap specifications
          local keymaps = {
            {
              "<leader>cl",
              function()
                Snacks.picker.lsp_config()
              end,
              desc = "Lsp Info",
            },
            { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
            { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
            { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
            { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
            { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
            {
              "K",
              function()
                return vim.lsp.buf.hover()
              end,
              desc = "Hover",
            },
            {
              "gK",
              function()
                return vim.lsp.buf.signature_help()
              end,
              desc = "Signature Help",
              has = "signatureHelp",
            },
            {
              "<c-k>",
              function()
                return vim.lsp.buf.signature_help()
              end,
              mode = "i",
              desc = "Signature Help",
              has = "signatureHelp",
            },
            { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
            { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "codeLens" },
            {
              "<leader>cC",
              vim.lsp.codelens.refresh,
              desc = "Refresh & Display Codelens",
              mode = { "n" },
              has = "codeLens",
            },
            {
              "<leader>cR",
              function()
                Snacks.rename.rename_file()
              end,
              desc = "Rename File",
              mode = { "n" },
              has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
            },
            { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
            {
              "<leader>cA",
              function()
                vim.lsp.buf.code_action({
                  context = { only = { "source" } },
                })
              end,
              desc = "Source Action",
              has = "codeAction",
            },
            {
              "]]",
              function()
                Snacks.words.jump(vim.v.count1)
              end,
              has = "documentHighlight",
              desc = "Next Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
            {
              "[[",
              function()
                Snacks.words.jump(-vim.v.count1)
              end,
              has = "documentHighlight",
              desc = "Prev Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
            {
              "<a-n>",
              function()
                Snacks.words.jump(vim.v.count1, true)
              end,
              has = "documentHighlight",
              desc = "Next Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
            {
              "<a-p>",
              function()
                Snacks.words.jump(-vim.v.count1, true)
              end,
              has = "documentHighlight",
              desc = "Prev Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
          }

          -- Helper function: Check if the client supports the method(s) specified in the `has` field.
          local function supports_required(has)
            if type(has) == "string" then
              -- Try the convention "textDocument/<method>" first.
              return client.supports_method("textDocument/" .. has) or client.supports_method(has)
            elseif type(has) == "table" then
              for _, method in ipairs(has) do
                if client.supports_method(method) then
                  return true
                end
              end
              return false
            else
              return true
            end
          end

          -- Iterate over and set each keymap conditionally.
          for _, map in ipairs(keymaps) do
            local key = map[1]
            local rhs = map[2]
            local opts = { desc = map.desc, buffer = bufnr }
            -- If mode is specified, use it (default is "n" for normal mode).
            local mode = map.mode or "n"

            -- Check for an arbitrary condition, if provided.
            if map.cond and type(map.cond) == "function" and not map.cond() then
              goto continue
            end

            -- If the optional "has" field is specified, only add it if the client supports it.
            if map.has and not supports_required(map.has) then
              goto continue
            end

            -- Pass through any extra options, e.g. nowait.
            if map.nowait then
              opts.nowait = true
            end

            vim.keymap.set(mode, key, rhs, opts)
            ::continue::
          end
        end,
      })

      -- Helper function to mimic LazyVim's on_supports_method functionality.
      local function on_supports_method(method, callback)
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            local bufnr = event.buf
            if client and client.supports_method(method) then
              callback(client, bufnr)
            end
          end,
        })
      end

      -- Check that Neovim version 0.10 (or later) is available.
      if vim.fn.has("nvim-0.10") == 1 then
        if opts.inlay_hints.enabled then
          -- This will attach our callback for any LSP that supports textDocument/inlayHint.
          on_supports_method("textDocument/inlayHint", function(client, bufnr)
            -- Additional checks: make sure the buffer is valid, it is a normal buffer, and its filetype is not excluded.
            if
              vim.api.nvim_buf_is_valid(bufnr)
              and vim.bo[bufnr].buftype == ""
              and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[bufnr].filetype)
            then
              -- Enable inlay hints for this buffer.
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
          end)
        end
      end
      -- diagnostics signs
      if vim.fn.has("nvim-0.10.0") == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
          end
        end
      end
      -- Ensure that the features below run only when we are on Neovim 0.10.0 or later.
      if vim.fn.has("nvim-0.10.0") == 1 then
        if opts.codelens.enabled and vim.lsp.codelens then
          -- -- Mimic LazyVim.lsp.on_supports_method:
          -- local function on_supports_method(method, callback)
          --   vim.api.nvim_create_autocmd("LspAttach", {
          --     callback = function(event)
          --       local client = vim.lsp.get_client_by_id(event.data.client_id)
          --       if client and client.supports_method(method) then
          --         callback(client, event.buf)
          --       end
          --     end,
          --   })
          -- end
          on_supports_method("textDocument/codeLens", function(client, buffer)
            -- Initial refresh for CodeLens
            vim.lsp.codelens.refresh()

            -- Refresh CodeLens on certain buffer-related events
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = buffer,
              callback = function()
                vim.lsp.codelens.refresh()
              end,
            })
          end)
        end
      else
        vim.notify("CodeLens feature requires Neovim 0.10.0 or higher", vim.log.levels.WARN)
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      -- if have_mason then
      --   -- all_mslp_servers = vim.tbl_keys(require("mason-lspconfig").get_available_servers())
      --   all_mslp_servers =require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
      -- end
      if have_mason and vim.fn.has("nvim-0.11") == 1 then
        -- all_mslp_servers = vim.tbl_keys(require("mason-lspconfig").get_mappings().lspconfig_to_package)
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig").get_available_servers())
      elseif have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end
      -- Check if mason-lspconfig is available
      local mason_status, mason_lspconfig = pcall(require, "mason-lspconfig")
      if mason_status then
        -- Define a base list of servers you want to ensure is installed
        local base_ensure_installed = { "lua_ls", "pyright" } -- adjust as needed

        -- Mimic LazyVim's configuration for mason-lspconfig.
        -- You might get this from a user settings file or just define directly.
        local custom_mason_config = {
          ensure_installed = { "html", "cssls" }, -- additional servers to install
        }

        -- Merge the two lists. The "force" mode ensures that if there are conflicting keys,
        -- values from custom_mason_config take precedence.
        local merged_ensure_installed =
          vim.tbl_deep_extend("force", ensure_installed, custom_mason_config.ensure_installed or {})

        -- Define a generic setup handler for configuring each LSP server.
        -- You can customize this function to add server-specific settings.
        local lspconfig = require("lspconfig")
        local function setup(server_name)
          -- Default options; customize as appropriate for your configuration.
          local opts = {}
          lspconfig[server_name].setup(opts)
        end

        -- Now setup mason-lspconfig
        mason_lspconfig.setup({
          ensure_installed = merged_ensure_installed,
          handlers = { setup },
        })
      end
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      -- Replace these flags with however you signal that these servers are enabled.
      local denols_enabled = true
      local vtsls_enabled = true

      if denols_enabled and vtsls_enabled then
        -- Define a function that checks if a given project root is a Deno project.
        local is_deno = util.root_pattern("deno.json", "deno.jsonc")

        -- Setup vtsls so that if the root matches a Deno project, we disable it
        -- by removing the filetypes – preventing it from attaching.
        lspconfig.vtsls.setup({
          -- Your other vtsls settings go here…
          on_new_config = function(new_config, root_dir)
            if is_deno(root_dir) then
              -- Clearing filetypes will effectively disable the server in this project.
              new_config.filetypes = {}
            end
          end,
        })

        -- Setup denols so that in non-Deno projects, we disable the Deno features
        -- in its settings (effectively “disabling” denols).
        lspconfig.denols.setup({
          -- Your other denols settings go here…
          on_new_config = function(new_config, root_dir)
            if not is_deno(root_dir) then
              new_config.settings = new_config.settings or {}
              new_config.settings.deno = new_config.settings.deno or {}
              -- Disable deno functionality in non-deno projects.
              new_config.settings.deno.enable = false
            end
            -- Always return false to mimic the LazyVim callback behavior.
            return false
          end,
        })
      end
    end,
  },
}
