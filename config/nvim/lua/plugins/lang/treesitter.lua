return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            lazy = true,
        },
    },
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
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    -- Rust-specific text objects
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
                    ["ac"] = "@conditional.outer",
                    ["ic"] = "@conditional.inner",
                    ["am"] = "@comment.outer",
                    ["as"] = "@statement.outer",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]f"] = "@function.outer",
                    ["]c"] = "@class.outer",
                    ["]a"] = "@parameter.inner",
                    ["]b"] = "@block.outer",
                    ["]l"] = "@loop.outer",
                    ["]s"] = "@statement.outer",
                },
                goto_next_end = {
                    ["]F"] = "@function.outer",
                    ["]C"] = "@class.outer",
                    ["]A"] = "@parameter.inner",
                    ["]B"] = "@block.outer",
                    ["]L"] = "@loop.outer",
                    ["]S"] = "@statement.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[c"] = "@class.outer",
                    ["[a"] = "@parameter.inner",
                    ["[b"] = "@block.outer",
                    ["[l"] = "@loop.outer",
                    ["[s"] = "@statement.outer",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    ["[C"] = "@class.outer",
                    ["[A"] = "@parameter.inner",
                    ["[B"] = "@block.outer",
                    ["[L"] = "@loop.outer",
                    ["[S"] = "@statement.outer",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>sp"] = "@parameter.inner",
                    ["<leader>sf"] = "@function.outer",
                },
                swap_previous = {
                    ["<leader>sP"] = "@parameter.inner",
                    ["<leader>sF"] = "@function.outer",
                },
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
