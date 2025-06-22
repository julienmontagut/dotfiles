return {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
        -- Disable default tab mapping since we use nvim-cmp
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true

        -- Enable Copilot for specific filetypes
        vim.g.copilot_filetypes = {
            ["*"] = false,
            ["javascript"] = true,
            ["typescript"] = true,
            ["lua"] = true,
            ["rust"] = true,
            ["python"] = true,
            ["go"] = true,
            ["java"] = true,
            ["c"] = true,
            ["cpp"] = true,
            ["markdown"] = true,
            ["json"] = true,
            ["yaml"] = true,
            ["toml"] = true,
        }

        -- Keymaps
        vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
            expr = true,
            replace_keycodes = false,
            desc = "Accept Copilot suggestion",
        })

        vim.keymap.set("i", "<C-;>", "<Plug>(copilot-dismiss)", {
            desc = "Dismiss Copilot suggestion",
        })

        vim.keymap.set("i", "<C-]>", "<Plug>(copilot-next)", {
            desc = "Next Copilot suggestion",
        })

        vim.keymap.set("i", "<C-[>", "<Plug>(copilot-previous)", {
            desc = "Previous Copilot suggestion",
        })
    end,
}
