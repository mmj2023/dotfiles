return {
        'rcarriga/nvim-notify',
        event = 'VeryLazy',
        opts = {},
        config = function()
            local function get_background_color()
                local bg_color = vim.api.nvim_get_hl_by_name('Normal', true).background
                if bg_color then
                    return string.format('#%06x', bg_color)
                else
                    return '#000000' -- Default to black if no background color is found
                end
            end
            require('notify').setup({
                stages = 'fade_in_slide_out',
                timeout = 1500,
                background_colour = get_background_color(),
            })
            vim.notify = require('notify')
        end,
    }
