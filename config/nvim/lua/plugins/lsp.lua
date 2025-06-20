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

            -- Common on_attach function with semantic keybindings
            _G.common_on_attach = function(client, bufnr)
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                local opts = { noremap = true, silent = true, buffer = bufnr }

                -- Navigation (Go to...)
                vim.keymap.set(
                    "n",
                    "gD",
                    vim.lsp.buf.declaration,
                    vim.tbl_extend("force", opts, { desc = "Go to declaration" })
                )
                vim.keymap.set(
                    "n",
                    "gd",
                    vim.lsp.buf.definition,
                    vim.tbl_extend("force", opts, { desc = "Go to definition" })
                )
                vim.keymap.set(
                    "n",
                    "gi",
                    vim.lsp.buf.implementation,
                    vim.tbl_extend("force", opts, { desc = "Go to implementation" })
                )
                vim.keymap.set(
                    "n",
                    "gt",
                    vim.lsp.buf.type_definition,
                    vim.tbl_extend("force", opts, { desc = "Go to type definition" })
                )
                vim.keymap.set(
                    "n",
                    "gr",
                    vim.lsp.buf.references,
                    vim.tbl_extend("force", opts, { desc = "Show references" })
                )

                -- Information
                vim.keymap.set(
                    "n",
                    "K",
                    vim.lsp.buf.hover,
                    vim.tbl_extend("force", opts, { desc = "Show hover info" })
                )
                vim.keymap.set(
                    "n",
                    "<C-k>",
                    vim.lsp.buf.signature_help,
                    vim.tbl_extend("force", opts, { desc = "Show signature help" })
                )
                vim.keymap.set(
                    "i",
                    "<C-k>",
                    vim.lsp.buf.signature_help,
                    vim.tbl_extend("force", opts, { desc = "Show signature help" })
                )

                -- Code actions (c = code) - merge basic actions with code actions
                vim.keymap.set(
                    "n",
                    "<leader>cr",
                    vim.lsp.buf.rename,
                    vim.tbl_extend("force", opts, { desc = "Rename symbol" })
                )
                vim.keymap.set(
                    "n",
                    "<leader>ca",
                    vim.lsp.buf.code_action,
                    vim.tbl_extend("force", opts, { desc = "Code actions" })
                )
                vim.keymap.set("n", "<leader>cf", function()
                    vim.lsp.buf.format({ async = true })
                end, vim.tbl_extend("force", opts, { desc = "Format code" }))

                -- Diagnostics (d = diagnostic)
                vim.keymap.set(
                    "n",
                    "<leader>dn",
                    vim.diagnostic.goto_next,
                    vim.tbl_extend("force", opts, { desc = "Next diagnostic" })
                )
                vim.keymap.set(
                    "n",
                    "<leader>dp",
                    vim.diagnostic.goto_prev,
                    vim.tbl_extend("force", opts, { desc = "Previous diagnostic" })
                )
                vim.keymap.set(
                    "n",
                    "<leader>dd",
                    vim.diagnostic.open_float,
                    vim.tbl_extend("force", opts, { desc = "Show diagnostic" })
                )
                vim.keymap.set(
                    "n",
                    "<leader>dl",
                    vim.diagnostic.setloclist,
                    vim.tbl_extend("force", opts, { desc = "Diagnostics to loclist" })
                )

                -- Note: <leader>w* is reserved for window actions
                -- Workspace actions (use 'ws' prefix since less frequent)
                vim.keymap.set(
                    "n",
                    "<leader>sa",
                    vim.lsp.buf.add_workspace_folder,
                    vim.tbl_extend("force", opts, { desc = "Add workspace folder" })
                )
                vim.keymap.set(
                    "n",
                    "<leader>sr",
                    vim.lsp.buf.remove_workspace_folder,
                    vim.tbl_extend("force", opts, { desc = "Remove workspace folder" })
                )
                vim.keymap.set("n", "<leader>sl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, vim.tbl_extend(
                    "force",
                    opts,
                    { desc = "List workspace folders" }
                ))

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
