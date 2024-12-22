return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
        "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    },
    opts = {
        strategies = {
            chat = {
                adapter = "ollama",
                keymaps = {
                    close = {
                        modes = {
                            n = "<C-c>",
                            i = "<C-w>",
                        },
                    },
                },
            },
            agent = {
                adapter = "ollama",
            },
            inline = {
                adapter = "ollama",
            },
        },
    },
}
