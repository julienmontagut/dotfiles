return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
        "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
        { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    config = function()
        require("codecompanion").setup({
            strategies = {
                chat = {
                    adapter = "anthropic",
                },
                inline = {
                    adapter = "anthropic",
                },
                agent = {
                    adapter = "anthropic",
                },
            },
            adapters = {
                anthropic = function()
                    return require("codecompanion.adapters").extend("anthropic", {
                        env = {
                            api_key = "ANTHROPIC_API_KEY",
                        },
                    })
                end,
            },
            opts = {
                log_level = "ERROR",
            },
            display = {
                diff = {
                    provider = "mini_diff",
                },
            },
        })
    end,
    keys = {
        {
            "<C-a>",
            "<cmd>CodeCompanionActions<cr>",
            mode = { "n", "v" },
            desc = "Code Companion Actions",
        },
        {
            "<leader>a",
            "<cmd>CodeCompanionChat Toggle<cr>",
            mode = { "n", "v" },
            desc = "Toggle Code Companion Chat",
        },
        { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to Code Companion Chat" },
    },
}
