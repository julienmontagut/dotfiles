return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "lua",
                "markdown",
                "markdown_inline",
                "query",
                "regex",
                "vim",
                "vimdoc",
                "rust",
                "toml",
            },
            auto_install = true,
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                },
                move = {
                    set_jumps = true,
                },
            })

            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")
            local swap = require("nvim-treesitter-textobjects.swap")

            -- Select keymaps
            local select_maps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["am"] = "@comment.outer",
                ["as"] = "@statement.outer",
            }
            for key, query in pairs(select_maps) do
                vim.keymap.set({ "x", "o" }, key, function()
                    select.select_textobject(query, "textobjects")
                end)
            end

            -- Move keymaps
            local move_next_start = {
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer",
                ["]a"] = "@parameter.inner",
                ["]b"] = "@block.outer",
                ["]l"] = "@loop.outer",
                ["]s"] = "@statement.outer",
            }
            local move_next_end = {
                ["]F"] = "@function.outer",
                ["]C"] = "@class.outer",
                ["]A"] = "@parameter.inner",
                ["]B"] = "@block.outer",
                ["]L"] = "@loop.outer",
                ["]S"] = "@statement.outer",
            }
            local move_prev_start = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
                ["[a"] = "@parameter.inner",
                ["[b"] = "@block.outer",
                ["[l"] = "@loop.outer",
                ["[s"] = "@statement.outer",
            }
            local move_prev_end = {
                ["[F"] = "@function.outer",
                ["[C"] = "@class.outer",
                ["[A"] = "@parameter.inner",
                ["[B"] = "@block.outer",
                ["[L"] = "@loop.outer",
                ["[S"] = "@statement.outer",
            }
            for key, query in pairs(move_next_start) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    move.goto_next_start(query, "textobjects")
                end)
            end
            for key, query in pairs(move_next_end) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    move.goto_next_end(query, "textobjects")
                end)
            end
            for key, query in pairs(move_prev_start) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    move.goto_previous_start(query, "textobjects")
                end)
            end
            for key, query in pairs(move_prev_end) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    move.goto_previous_end(query, "textobjects")
                end)
            end

            -- Swap keymaps
            vim.keymap.set("n", "<leader>sp", function()
                swap.swap_next("@parameter.inner")
            end)
            vim.keymap.set("n", "<leader>sf", function()
                swap.swap_next("@function.outer")
            end)
            vim.keymap.set("n", "<leader>sP", function()
                swap.swap_previous("@parameter.inner")
            end)
            vim.keymap.set("n", "<leader>sF", function()
                swap.swap_previous("@function.outer")
            end)
        end,
    },
}
