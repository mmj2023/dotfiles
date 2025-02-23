return {
  "danymat/neogen",
  cmd = "Neogen",
  keys = {
    {
      "<leader>gcn",
      function()
        require("neogen").generate()
      end,
      desc = "Generate Annotations (Neogen)",
    },
  },
  opts = function(_, opts)
    if opts.snippet_engine ~= nil then
      return
    end

    -- local map = {
    --   ["LuaSnip"] = "luasnip",
    --   ["nvim-snippy"] = "snippy",
    --   ["vim-vsnip"] = "vsnip",
    -- }
    --
    -- opts.snippet_engine = engine

    if vim.snippet then
      opts.snippet_engine = "nvim"
    end
  end,
}
