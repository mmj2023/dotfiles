return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    -- event = { "BufReadPre", "BufNewFile", "VeryLazy", "BufRead", "BufNew", "BufAdd", "BufEnter", "BufWinEnter" },
    ---@module "ufo"
    ---@type ufo.Setup
    opts = {
      fold_virt_text = true,
      preview = {
        mappings = {
          scrollB = "<C-B>",
          scrollF = "<C-F>",
          scrollU = "<C-U>",
          scrollD = "<C-D>",
        },
      },

      provider_selector = function(_, filetype, buftype)
        local function handleFallbackException(bufnr, err, providerName)
          if type(err) == "string" and err:match("UfoFallbackException") then
            return require("ufo").getFolds(bufnr, providerName)
          else
            return require("promise").reject(err)
          end
        end

        return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
          or function(bufnr)
            return require("ufo")
              .getFolds(bufnr, "lsp")
              :catch(function(err)
                return handleFallbackException(bufnr, err, "treesitter")
              end)
              :catch(function(err)
                return handleFallbackException(bufnr, err, "indent")
              end)
          end
      end,

      -- provider_selector = function(bufnr, filetype, buftype)
      -- local servers = require("ufo").get_servers()
      -- if servers["pyright"] then
      --   return "pyright"
      -- elseif servers["tsserver"] then
      --   return "tsserver"
      -- elseif servers["clangd"] then
      --   return "clangd"
      -- elseif servers["rust_analyzer"] then
      --   return "rust_analyzer"
      -- end
      -- return {--[[ "lsp", ]]
      --   "treesitter",
      --   "indent",
      -- }
      -- end,
    },
    ---@param opts ufo.Setup
    config = function(_, opts)
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.cmd([[set nofoldenable]])
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      -- vim.opt.statuscolumn = "%=%{v:lnum} %{%foldlevel(v:lnum)>0?'▶':''%}"
      -- local function show_folds()
      --   local ns = vim.api.nvim_create_namespace("fold_markers")
      --   vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
      --
      --   for line = 1, vim.fn.line("$") do
      --     if vim.fn.foldlevel(line) > 0 then
      --       local fold_marker = vim.fn.foldclosed(line) == -1 and "▼" or "▶"
      --       vim.api.nvim_buf_set_extmark(0, ns, line - 1, -1, {
      --         virt_text = { { fold_marker, "Comment" } },
      --         virt_text_pos = "right_align",
      --       })
      --     end
      --   end
      -- end
      --
      -- vim.api.nvim_create_autocmd({ "WinScrolled", "BufWinEnter" }, {
      --   callback = show_folds,
      -- })
      require("ufo").setup(opts)
    end,
    keys = {
      { "zO", "<cmd>lua require('ufo').openAllFolds()<cr>", desc = "Open all folds" },
      { "zC", "<cmd>lua require('ufo').closeAllFolds()<cr>", desc = "Close all folds" },
      {
        "zP",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Preview Folds",
      },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        desc = "Fold less",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        desc = "Fold more",
      },
      {
        "zp",
        function()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        desc = "Peek fold",
      },
    },
  },
}
