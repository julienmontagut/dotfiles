return {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
    opts = {
        display = {
            open_cmd = "vnew",
            open_height = 0.8,
            open_width = 0.8,
        },
        diagnostics = {
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
        },
    },
}
