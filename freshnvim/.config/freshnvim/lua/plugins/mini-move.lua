return {
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
        opts = {
            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                -- Move visual selection in Visual mode. Defaults are <F2> + hjkl.
                left = '<F2>h',
                right = '<F2>l',
                down = '<F2>j',
                up = '<F2>k',

                -- Move current line in Normal mode
                line_left = '<F2>h',
                line_right = '<F2>l',
                line_down = '<F2>j',
                line_up = '<F2>k',
            },

            -- Options which control moving behavior
            options = {
                -- Automatically reindent selection during linewise vertical move
                reindent_linewise = true,
            },
        },
        keys = {
            { "<F2>h" , "<F2>hgv", mode= "v", desc = "move <F2>h then highlight the previous highlight again", },
            { "<F2>j" , "<F2>jgv", mode= "v", desc = "move <F2>j then highlight the previous highlight again", },
            { "<F2>k" , "<F2>kgv", mode= "v", desc = "move <F2>k then highlight the previous highlight again", },
            { "<F2>l" , "<F2>lgv", mode= "v", desc = "move <F2>l then highlight the previous highlight again", },
        },
  },
}
