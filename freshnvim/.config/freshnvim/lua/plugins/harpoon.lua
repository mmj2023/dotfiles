return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local keys = {
      {
        "<leader>+",
        function()
          require("harpoon"):list():add()
          vim.notify("Harpooned File Added", {}, {
            title = "󱡅 Harpoon" --[[ , border = "rounded" ]],
            align = "center",
          })
        end,
        desc = "Harpoon File",
      },
      {
        "<leader>fl",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Toggle Quick Menu",
      },
    }

    for i = 1, 10 do
      local p = i
      if i == 10 then
        p = 0
      end
      table.insert(keys, {
        "<leader>" .. p,
        function()
          require("harpoon"):list():select(p)
          -- vim.notify('Harpoon to File ' .. p)
        end,
        desc = "Harpoon to File " .. p,
      })
    end
    return keys
  end,
}
