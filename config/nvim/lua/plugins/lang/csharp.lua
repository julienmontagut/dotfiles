return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                omnisharp = {
                    -- Enable this to enable Roslyn analyzers, code actions, and diagnostics.
                    enable_roslyn_analyzers = true,
                    -- Enable this to enable import completion
                    enable_import_completion = true,
                    -- Enable this to enable code actions
                    enable_code_actions = true,
                    -- Enable this to enable semantic tokens
                    enable_semantic_tokens = true,
                    -- Enable this to enable format on save
                    enable_format_on_save = true,
                },
            },
            setup = {
                omnisharp = function()
                    require("lspconfig").omnisharp.setup({
                        handlers = {
                            ["textDocument/definition"] = require("omnisharp_extended").handler,
                        },
                        on_attach = function(client, bufnr)
                            -- Use common LSP attachments first
                            _G.common_on_attach(client, bufnr)
                            local opts = { noremap = true, silent = true, buffer = bufnr }
                            vim.keymap.set(
                                "n",
                                "gd",
                                require("omnisharp_extended").telescope_lsp_definitions,
                                opts
                            )
                        end,
                    })
                    return true
                end,
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { "c_sharp" })
        end,
    },
    {
        "Hoffs/omnisharp-extended-lsp.nvim",
        lazy = true,
    },
}
