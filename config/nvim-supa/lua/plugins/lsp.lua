return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "folke/neodev.nvim",
            "stevearc/dressing.nvim",
        },
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    prefix = "●",
                    source = "if_many",
                },
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = "always",
                },
            },
            inlay_hints = {
                enabled = true,
            },
            capabilities = {},
        },
        config = function(_, opts)
            -- Setup LSP capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})

            -- Common on_attach function that can be used by language configs
            _G.common_on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                -- Key mappings
                local map_opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, map_opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, map_opts)
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, map_opts)
                vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, map_opts)
                vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, map_opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, map_opts)

                -- Enable inlay hints if supported
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(bufnr, true)
                end
            end

            -- Apply diagnostic configuration
            vim.diagnostic.config(opts.diagnostics)
        end,
    },
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            notification = {
                window = {
                    winblend = 0,
                    border = "rounded",
                },
            },
        },
    },
}
