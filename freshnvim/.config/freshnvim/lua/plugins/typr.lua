return {
  "nvzone/typr",
  dependencies = "nvzone/volt",
  opts = {
    wpm_goal = 120,
    mappings = function(buf)
      vim.keymap.set("n", "<esc>", "<cmd>quit<CR>", { buffer = buf })
      vim.keymap.set("n", "q", "<cmd>quit<CR>", { buffer = buf })
    end,
    on_attach = function(buf)
      vim.b[buf].minipairs_disable = true
    end,
  },
  cmd = { "Typr", "TyprStats" },
}
