return {
  "folke/flash.nvim",
  -- event = "VeryLazy",
  vscode = true,
  ---@type Flash.Config
  opts = {},
    -- stylua: ignore
    -- TODO: change the keybindings to <leader><then, default keys> If user starts using mini-surround
    keys = {
        { "[s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "[S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "[r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "[R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-e>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        {"f"},
    },
}
