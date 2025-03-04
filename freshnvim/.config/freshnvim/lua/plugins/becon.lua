return {
    "DanilaMihailov/beacon.nvim",
    event = "VeryLazy",
    opts = {
        beacon = {
            enable = true,
            frequency = 1000,
            blink_during_fully_covered = 0,
            fade_in_dur = 100,
            fade_out_dur = 100,
            shape = "circle",
            virtual_text = true,
            virt_text_pos = "eol",
            virt_lines = false,
            line = nil,
            char = nil,
        },
    },
}
