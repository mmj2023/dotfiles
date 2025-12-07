---@param opts? {level?: number}
function fresh_pretty_trace(opts)
  opts = opts or {}
  local Config = require("lazy.core.config")
  local trace = {}
  local level = opts.level or 2
  while true do
    local info = debug.getinfo(level, "Sln")
    if not info then
      break
    end
    if info.what ~= "C" and (Config.options.debug or not info.source:find("lazy.nvim")) then
      local source = info.source:sub(2)
      if source:find(Config.options.root, 1, true) == 1 then
        source = source:sub(#Config.options.root + 1)
      end
      source = vim.fn.fnamemodify(source, ":p:~:.") --[[@as string]]
      local line = "  - " .. source .. ":" .. info.currentline
      if info.name then
        line = line .. " _in_ **" .. info.name .. "**"
      end
      table.insert(trace, line)
    end
    level = level + 1
  end
  return #trace > 0 and ("\n\n# stacktrace:\n" .. table.concat(trace, "\n")) or ""
end

---@param msg string|string[]
---@param opts? LazyNotifyOpts
function fresh_notify(msg, opts)
  if vim.in_fast_event() then
    return vim.schedule(function()
      fresh_notify(msg, opts)
    end)
  end

  opts = opts or {}
  if type(msg) == "table" then
    msg = table.concat(
      vim.tbl_filter(function(line)
        return line or false
      end, msg),
      "\n"
    )
  end
  if opts.stacktrace then
    msg = msg .. fresh_pretty_trace({ level = opts.stacklevel or 2 })
  end
  local lang = opts.lang or "markdown"
  local n = opts.once and vim.notify_once or vim.notify
  n(msg, opts.level or vim.log.levels.INFO, {
    ft = lang,
    on_open = function(win)
      local ok = pcall(function()
        vim.treesitter.language.add("markdown")
      end)
      if not ok then
        pcall(require, "nvim-treesitter")
      end
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, lang) then
        vim.bo[buf].filetype = lang
        vim.bo[buf].syntax = lang
      end
    end,
    title = opts.title or "lazy.nvim",
  })
end

---@param name string
function get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
function local_opts(name)
  local plugin = get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---@param plugin string
function has(plugin)
  return get_plugin(plugin) ~= nil
end

---@param msg string|string[]
---@param opts? LazyNotifyOpts
function warn(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.WARN
  fresh_notify(msg, opts)
end
_options = {} ---@type vim.wo|vim.bo
---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
local_lsp_supports_method = {}

---@param method string
---@param fn fun(client:vim.lsp.Client, buffer)
function local_lsp_on_supports_method(method, fn)
  local_lsp_supports_method[method] = local_lsp_supports_method[method] or setmetatable({}, { __mode = "k" })
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end

function lsp_keybind_on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = resolve(buffer)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      local opts = Keys.opts(keys)
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end
---@param client vim.lsp.Client
function local_lsp_check_methods(client, buffer)
  -- don't trigger on invalid buffers
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end
  -- don't trigger on non-listed buffers
  if not vim.bo[buffer].buflisted then
    return
  end
  -- don't trigger on nofile buffers
  if vim.bo[buffer].buftype == "nofile" then
    return
  end
  for method, clients in pairs(local_lsp_supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] then
      if client.supports_method and client:supports_method(method, buffer) then
        clients[client][buffer] = true
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspSupportsMethod",
          data = { client_id = client.id, buffer = buffer, method = method },
        })
      end
    end
  end
end

---@param fn fun(client:vim.lsp.Client, buffer):boolean?
---@param opts? {group?: integer}
function lsp_on_dynamic_capability(fn, opts)
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspDynamicCapability",
    group = opts and opts.group or nil,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client then
        return fn(client, buffer)
      end
    end,
  })
end

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function lsp_on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

function lsp_setup()
  local register_capability = vim.lsp.handlers["client/registerCapability"]
  vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    ---@diagnostic disable-next-line: no-unknown
    local ret = register_capability(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buffer in pairs(client.attached_buffers) do
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspDynamicCapability",
          data = { client_id = client.id, buffer = buffer },
        })
      end
    end
    return ret
  end
  lsp_on_attach(local_lsp_check_methods)
  lsp_on_dynamic_capability(local_lsp_check_methods)
end
-- set default
function local_lsp_set_default(option, value)
  local l = vim.api.nvim_get_option_value(option, { scope = "local" })
  local g = _options[option] or vim.api.nvim_get_option_value(option, { scope = "global" })

  _defaults[("%s=%s"):format(option, value)] = true
  local key = ("%s=%s"):format(option, l)

  local source = ""
  if l ~= g and not _defaults[key] then
    -- Option does not match global and is not a default value
    -- Check if it was set by a script in $VIMRUNTIME
    local info = vim.api.nvim_get_option_info2(option, { scope = "local" })
    ---@param e vim.fn.getscriptinfo.ret
    local scriptinfo = vim.tbl_filter(function(e)
      return e.sid == info.last_set_sid
    end, vim.fn.getscriptinfo())
    source = scriptinfo[1] and scriptinfo[1].name or ""
    local by_rtp = #scriptinfo == 1 and vim.startswith(scriptinfo[1].name, vim.fn.expand("$VIMRUNTIME"))
    if not by_rtp then
      if vim.g.lazyvim_debug_set_default then
        warn(
          ("Not setting option `%s` to `%q` because it was changed by a plugin."):format(option, value),
          { title = "FreshNvim", once = true }
        )
      end
      return false
    end
  end

  -- if vim.g.lazyvim_debug_set_default then
  --   LazyVim.info({
  --     ("Setting option `%s` to `%q`"):format(option, value),
  --     ("Was: %q"):format(l),
  --     ("Global: %q"):format(g),
  --     source ~= "" and ("Last set by: %s"):format(source) or "",
  --     "buf: " .. vim.api.nvim_buf_get_name(0),
  --   }, { title = "LazyVim", once = true })
  -- end

  vim.api.nvim_set_option_value(option, value, { scope = "local" })
  return true
end

---@return LazyKeysLsp[]
function resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = vim.tbl_extend("force", {}, get_keymap())
  local opts = local_opts("nvim-lspconfig")
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

---@type LazyKeysLspSpec[]|nil
lsp_keys = nil

lsp_action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

---@return LazyKeysLspSpec[]
function get_keymap()
  if lsp_keys then
    return lsp_keys
  end
    -- stylua: ignore
    lsp_keys =  {
      { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
      { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
      { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
      { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
      { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
      { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
      { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "codeLens" },
      { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
      { "<leader>cA", lsp_action.source, desc = "Source Action", has = "codeAction" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight",
        desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight",
        desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
      { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight",
        desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
      { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
        desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
    }

  return lsp_keys
end

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
          -- Rust LS configuration
          rust_analyzer = {
            -- Enables `rust-analyzer`'s inlay hints.
            -- These are the type hints that often appear inline in your code,
            -- showing inferred types, parameter names, etc.
            --  settings = {
            --        inlayHints = {
            --     bindingMode = {
            --        enable = true,
            --        hideForConst = true,
            --      },
            --      chainingHints = {},
            --     },
            --  },
            -- },
          },
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
          -- Haskell Language Server
          hls = {
            mason = true,
            filetypes = { "haskell", "lhaskell", "cabal" },
            settings = {
              haskell = {
                formattingProvider = "ormolu",
                hlintOn = true,
                plugin = { ghcide = { globalOn = true } },
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
          fortls = {
            cmd = { "fortls" },
            filetypes = { "fortran" },
            -- root_dir = lspconfig.util.root_pattern(".fortls", ".git", "."),
            settings = {
              nthreads = 8, -- adjust for your CPU
              autocomplete = true,
              hover = true,
              symbols = true,
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
    -- config = function(_, opts)
    --   -- vim.api.nvim_create_autocmd("LspAttach", {
    --   --   callback = function(event)
    --   --     local bufnr = event.buf
    --   --     local client = vim.lsp.get_client_by_id(event.data.client_id)
    --   --
    --   --     -- Define your keymap specifications
    --   --     local keymaps = {
    --   --       {
    --   --         "<leader>cl",
    --   --         function()
    --   --           Snacks.picker.lsp_config()
    --   --         end,
    --   --         desc = "Lsp Info",
    --   --       },
    --   --       { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
    --   --       { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
    --   --       { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
    --   --       { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
    --   --       { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
    --   --       {
    --   --         "K",
    --   --         function()
    --   --           return vim.lsp.buf.hover()
    --   --         end,
    --   --         desc = "Hover",
    --   --       },
    --   --       {
    --   --         "gK",
    --   --         function()
    --   --           return vim.lsp.buf.signature_help()
    --   --         end,
    --   --         desc = "Signature Help",
    --   --         has = "signatureHelp",
    --   --       },
    --   --       {
    --   --         "<c-k>",
    --   --         function()
    --   --           return vim.lsp.buf.signature_help()
    --   --         end,
    --   --         mode = "i",
    --   --         desc = "Signature Help",
    --   --         has = "signatureHelp",
    --   --       },
    --   --       { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
    --   --       { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "codeLens" },
    --   --       {
    --   --         "<leader>cC",
    --   --         vim.lsp.codelens.refresh,
    --   --         desc = "Refresh & Display Codelens",
    --   --         mode = { "n" },
    --   --         has = "codeLens",
    --   --       },
    --   --       {
    --   --         "<leader>cR",
    --   --         function()
    --   --           Snacks.rename.rename_file()
    --   --         end,
    --   --         desc = "Rename File",
    --   --         mode = { "n" },
    --   --         has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
    --   --       },
    --   --       { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
    --   --       {
    --   --         "<leader>cA",
    --   --         function()
    --   --           vim.lsp.buf.code_action({
    --   --             context = { only = { "source" } },
    --   --           })
    --   --         end,
    --   --         desc = "Source Action",
    --   --         has = "codeAction",
    --   --       },
    --   --       {
    --   --         "]]",
    --   --         function()
    --   --           Snacks.words.jump(vim.v.count1)
    --   --         end,
    --   --         has = "documentHighlight",
    --   --         desc = "Next Reference",
    --   --         cond = function()
    --   --           return Snacks.words.is_enabled()
    --   --         end,
    --   --       },
    --   --       {
    --   --         "[[",
    --   --         function()
    --   --           Snacks.words.jump(-vim.v.count1)
    --   --         end,
    --   --         has = "documentHighlight",
    --   --         desc = "Prev Reference",
    --   --         cond = function()
    --   --           return Snacks.words.is_enabled()
    --   --         end,
    --   --       },
    --   --       {
    --   --         "<a-n>",
    --   --         function()
    --   --           Snacks.words.jump(vim.v.count1, true)
    --   --         end,
    --   --         has = "documentHighlight",
    --   --         desc = "Next Reference",
    --   --         cond = function()
    --   --           return Snacks.words.is_enabled()
    --   --         end,
    --   --       },
    --   --       {
    --   --         "<a-p>",
    --   --         function()
    --   --           Snacks.words.jump(-vim.v.count1, true)
    --   --         end,
    --   --         has = "documentHighlight",
    --   --         desc = "Prev Reference",
    --   --         cond = function()
    --   --           return Snacks.words.is_enabled()
    --   --         end,
    --   --       },
    --   --     }
    --   --
    --   --     -- Helper function: Check if the client supports the method(s) specified in the `has` field.
    --   --     local function supports_required(has)
    --   --       if type(has) == "string" then
    --   --         -- Try the convention "textDocument/<method>" first.
    --   --         return client.supports_method("textDocument/" .. has) or client.supports_method(has)
    --   --       elseif type(has) == "table" then
    --   --         for _, method in ipairs(has) do
    --   --           if client.supports_method(method) then
    --   --             return true
    --   --           end
    --   --         end
    --   --         return false
    --   --       else
    --   --         return true
    --   --       end
    --   --     end
    --   --
    --   --     -- Iterate over and set each keymap conditionally.
    --   --     for _, map in ipairs(keymaps) do
    --   --       local key = map[1]
    --   --       local rhs = map[2]
    --   --       local opts = { desc = map.desc, buffer = bufnr }
    --   --       -- If mode is specified, use it (default is "n" for normal mode).
    --   --       local mode = map.mode or "n"
    --   --
    --   --       -- Check for an arbitrary condition, if provided.
    --   --       if map.cond and type(map.cond) == "function" and not map.cond() then
    --   --         goto continue
    --   --       end
    --   --
    --   --       -- If the optional "has" field is specified, only add it if the client supports it.
    --   --       if map.has and not supports_required(map.has) then
    --   --         goto continue
    --   --       end
    --   --
    --   --       -- Pass through any extra options, e.g. nowait.
    --   --       if map.nowait then
    --   --         opts.nowait = true
    --   --       end
    --   --
    --   --       vim.keymap.set(mode, key, rhs, opts)
    --   --       ::continue::
    --   --     end
    --   --   end,
    --   -- })
    --   --
    --   -- -- Helper function to mimic LazyVim's on_supports_method functionality.
    --   -- local function on_supports_method(method, callback)
    --   --   vim.api.nvim_create_autocmd("LspAttach", {
    --   --     callback = function(event)
    --   --       local client = vim.lsp.get_client_by_id(event.data.client_id)
    --   --       local bufnr = event.buf
    --   --       if client and client.supports_method(method) then
    --   --         callback(client, bufnr)
    --   --       end
    --   --     end,
    --   --   })
    --   -- end
    --   --
    --   -- -- Check that Neovim version 0.10 (or later) is available.
    --   -- if vim.fn.has("nvim-0.10") == 1 then
    --   --   if opts.inlay_hints.enabled then
    --   --     -- This will attach our callback for any LSP that supports textDocument/inlayHint.
    --   --     on_supports_method("textDocument/inlayHint", function(client, bufnr)
    --   --       -- Additional checks: make sure the buffer is valid, it is a normal buffer, and its filetype is not excluded.
    --   --       if
    --   --         vim.api.nvim_buf_is_valid(bufnr)
    --   --         and vim.bo[bufnr].buftype == ""
    --   --         and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[bufnr].filetype)
    --   --       then
    --   --         -- Enable inlay hints for this buffer.
    --   --         vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    --   --       end
    --   --     end)
    --   --   end
    --   -- end
    --   -- -- diagnostics signs
    --   -- if vim.fn.has("nvim-0.10.0") == 0 then
    --   --   if type(opts.diagnostics.signs) ~= "boolean" then
    --   --     for severity, icon in pairs(opts.diagnostics.signs.text) do
    --   --       local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
    --   --       name = "DiagnosticSign" .. name
    --   --       vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    --   --     end
    --   --   end
    --   -- end
    --   -- -- Ensure that the features below run only when we are on Neovim 0.10.0 or later.
    --   -- if vim.fn.has("nvim-0.10.0") == 1 then
    --   --   if opts.codelens.enabled and vim.lsp.codelens then
    --   --     -- -- Mimic LazyVim.lsp.on_supports_method:
    --   --     -- local function on_supports_method(method, callback)
    --   --     --   vim.api.nvim_create_autocmd("LspAttach", {
    --   --     --     callback = function(event)
    --   --     --       local client = vim.lsp.get_client_by_id(event.data.client_id)
    --   --     --       if client and client.supports_method(method) then
    --   --     --         callback(client, event.buf)
    --   --     --       end
    --   --     --     end,
    --   --     --   })
    --   --     -- end
    --   --     on_supports_method("textDocument/codeLens", function(client, buffer)
    --   --       -- Initial refresh for CodeLens
    --   --       vim.lsp.codelens.refresh()
    --   --
    --   --       -- Refresh CodeLens on certain buffer-related events
    --   --       vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    --   --         buffer = buffer,
    --   --         callback = function()
    --   --           vim.lsp.codelens.refresh()
    --   --         end,
    --   --       })
    --   --     end)
    --   --   end
    --   -- else
    --   --   vim.notify("CodeLens feature requires Neovim 0.10.0 or higher", vim.log.levels.WARN)
    --   -- end
    --   --
    --   -- vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
    --   --
    --   -- local servers = opts.servers
    --   -- local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    --   -- local has_blink, blink = pcall(require, "blink.cmp")
    --   -- local capabilities = vim.tbl_deep_extend(
    --   --   "force",
    --   --   {},
    --   --   vim.lsp.protocol.make_client_capabilities(),
    --   --   has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    --   --   has_blink and blink.get_lsp_capabilities() or {},
    --   --   opts.capabilities or {}
    --   -- )
    --   --
    --   -- local function setup(server)
    --   --   local server_opts = vim.tbl_deep_extend("force", {
    --   --     capabilities = vim.deepcopy(capabilities),
    --   --   }, servers[server] or {})
    --   --   if server_opts.enabled == false then
    --   --     return
    --   --   end
    --   --
    --   --   if opts.setup[server] then
    --   --     if opts.setup[server](server, server_opts) then
    --   --       return
    --   --     end
    --   --   elseif opts.setup["*"] then
    --   --     if opts.setup["*"](server, server_opts) then
    --   --       return
    --   --     end
    --   --   end
    --   --   require("lspconfig")[server].setup(server_opts)
    --   -- end
    --   --
    --   -- -- get all the servers that are available through mason-lspconfig
    --   -- local have_mason, mlsp = pcall(require, "mason-lspconfig")
    --   -- local all_mslp_servers = {}
    --   -- -- if have_mason then
    --   -- --   -- all_mslp_servers = vim.tbl_keys(require("mason-lspconfig").get_available_servers())
    --   -- --   all_mslp_servers =require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
    --   -- -- end
    --   -- if have_mason and vim.fn.has("nvim-0.11") == 1 then
    --   --   -- all_mslp_servers = vim.tbl_keys(require("mason-lspconfig").get_mappings().lspconfig_to_package)
    --   --   all_mslp_servers = vim.tbl_keys(require("mason-lspconfig").get_available_servers())
    --   -- elseif have_mason then
    --   --   all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
    --   -- end
    --   --
    --   -- local ensure_installed = {} ---@type string[]
    --   -- for server, server_opts in pairs(servers) do
    --   --   if server_opts then
    --   --     server_opts = server_opts == true and {} or server_opts
    --   --     if server_opts.enabled ~= false then
    --   --       -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
    --   --       if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
    --   --         setup(server)
    --   --       else
    --   --         ensure_installed[#ensure_installed + 1] = server
    --   --       end
    --   --     end
    --   --   end
    --   -- end
    --   -- -- Check if mason-lspconfig is available
    --   -- local mason_status, mason_lspconfig = pcall(require, "mason-lspconfig")
    --   -- if mason_status then
    --   --   -- Define a base list of servers you want to ensure is installed
    --   --   local base_ensure_installed = { "lua_ls", "pyright" } -- adjust as needed
    --   --
    --   --   -- Mimic LazyVim's configuration for mason-lspconfig.
    --   --   -- You might get this from a user settings file or just define directly.
    --   --   local custom_mason_config = {
    --   --     ensure_installed = { "html", "cssls" }, -- additional servers to install
    --   --   }
    --   --
    --   --   -- Merge the two lists. The "force" mode ensures that if there are conflicting keys,
    --   --   -- values from custom_mason_config take precedence.
    --   --   local merged_ensure_installed =
    --   --     vim.tbl_deep_extend("force", ensure_installed, custom_mason_config.ensure_installed or {})
    --   --
    --   --   -- Define a generic setup handler for configuring each LSP server.
    --   --   -- You can customize this function to add server-specific settings.
    --   --   local lspconfig = require("lspconfig")
    --   --   local function setup(server_name)
    --   --     -- Default options; customize as appropriate for your configuration.
    --   --     local opts = {}
    --   --     lspconfig[server_name].setup(opts)
    --   --   end
    --   --
    --   --   -- Now setup mason-lspconfig
    --   --   mason_lspconfig.setup({
    --   --     ensure_installed = merged_ensure_installed,
    --   --     handlers = { setup },
    --   --   })
    --   -- end
    --   -- local lspconfig = require("lspconfig")
    --   -- local util = require("lspconfig.util")
    --   --
    --   -- -- Replace these flags with however you signal that these servers are enabled.
    --   -- local denols_enabled = true
    --   -- local vtsls_enabled = true
    --   --
    --   -- if denols_enabled and vtsls_enabled then
    --   --   -- Define a function that checks if a given project root is a Deno project.
    --   --   local is_deno = util.root_pattern("deno.json", "deno.jsonc")
    --   --
    --   --   -- Setup vtsls so that if the root matches a Deno project, we disable it
    --   --   -- by removing the filetypes – preventing it from attaching.
    --   --   lspconfig.vtsls.setup({
    --   --     -- Your other vtsls settings go here…
    --   --     on_new_config = function(new_config, root_dir)
    --   --       if is_deno(root_dir) then
    --   --         -- Clearing filetypes will effectively disable the server in this project.
    --   --         new_config.filetypes = {}
    --   --       end
    --   --     end,
    --   --   })
    --   --
    --   --   -- Setup denols so that in non-Deno projects, we disable the Deno features
    --   --   -- in its settings (effectively “disabling” denols).
    --   --   lspconfig.denols.setup({
    --   --     -- Your other denols settings go here…
    --   --     on_new_config = function(new_config, root_dir)
    --   --       if not is_deno(root_dir) then
    --   --         new_config.settings = new_config.settings or {}
    --   --         new_config.settings.deno = new_config.settings.deno or {}
    --   --         -- Disable deno functionality in non-deno projects.
    --   --         new_config.settings.deno.enable = false
    --   --       end
    --   --       -- Always return false to mimic the LazyVim callback behavior.
    --   --       return false
    --   --     end,
    --   --   })
    --   -- end
    -- end,
    config = vim.schedule_wrap(function(_, opts)
      -- -- setup autoformat
      -- LazyVim.format.register(LazyVim.lsp.formatter())

      -- -- setup keymaps
      -- LazyVim.lsp.on_attach(function(client, buffer)
      --   require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
      -- end)

      lsp_setup()
      lsp_on_dynamic_capability(lsp_keybind_on_attach)

      -- inlay hints
      if opts.inlay_hints.enabled then
        local_lsp_on_supports_method("textDocument/inlayHint", function(client, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- -- folds
      -- if opts.folds.enabled then
      --   local_lsp_on_supports_method("textDocument/foldingRange", function(client, buffer)
      --     if local_lsp_set_default("foldmethod", "expr") then
      --       local_lsp_set_default("foldexpr", "v:lua.vim.lsp.foldexpr()")
      --     end
      --   end)
      -- end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        local_lsp_on_supports_method("textDocument/codeLens", function(client, buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      -- diagnostics
      -- if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
      --   opts.diagnostics.virtual_text.prefix = function(diagnostic)
      --     local icons = LazyVim.config.icons.diagnostics
      --     for d, icon in pairs(icons) do
      --       if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
      --         return icon
      --       end
      --     end
      --     return "●"
      --   end
      -- end
      -- vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
      --
      if opts.capabilities then
        vim.lsp.config("*", { capabilities = opts.capabilities })
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason = has("mason-lspconfig.nvim")
      local mason_all = have_mason
          and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {} --[[ @as string[] ]]
      local mason_exclude = {} ---@type string[]

      ---@return boolean? exclude automatic setup
      local function configure(server)
        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as lazyvim.lsp.Config]]

        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end

        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, sopts) then
          mason_exclude[#mason_exclude + 1] = server
        else
          vim.lsp.config(server, sopts) -- configure the server
          if not use_mason then
            vim.lsp.enable(server)
          end
        end
        return use_mason
      end

      local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
      if have_mason then
        require("mason-lspconfig").setup({
          ensure_installed = vim.list_extend(install, local_opts("mason-lspconfig.nvim").ensure_installed or {}),
          automatic_enable = { exclude = mason_exclude },
        })
      end
    end),
  },
}
