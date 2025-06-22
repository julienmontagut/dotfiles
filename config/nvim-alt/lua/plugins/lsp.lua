return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local keymap = vim.keymap

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }

                opts.desc = "Show LSP references"
                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "Go to declaration"
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                opts.desc = "Show LSP definitions"
                keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

                opts.desc = "Show LSP implementations"
                keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

                opts.desc = "Show LSP type definitions"
                keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

                opts.desc = "See available code actions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

                opts.desc = "Smart rename"
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                opts.desc = "Show buffer diagnostics"
                keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

                opts.desc = "Show line diagnostics"
                keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

                opts.desc = "Go to previous diagnostic"
                keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

                opts.desc = "Go to next diagnostic"
                keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

                opts.desc = "Show documentation for what is under cursor"
                keymap.set("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "Restart LSP"
                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
            end,
        })

        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Configure more subtle diagnostics
        vim.diagnostic.config({
            virtual_text = {
                prefix = "●",
                spacing = 4,
                format = function(diagnostic)
                    -- Show only first line of diagnostic message
                    return string.match(diagnostic.message, "^[^\n]*")
                end,
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                source = "always",
                border = "rounded",
                max_width = 80,
                wrap = true,
                focusable = false,
            },
        })

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- Setup LSP servers conditionally based on binary availability
        local function setup_server_if_available(server_name, config)
            config = config or {}
            config.capabilities = capabilities

            local server_configs = {
                lua_ls = {
                    cmd = { "lua-language-server" },
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            completion = { callSnippet = "Replace" },
                        },
                    },
                },
                rust_analyzer = {
                    cmd = { "rust-analyzer" },
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = { command = "clippy" },
                        },
                    },
                },
                pyright = { cmd = { "pyright-langserver", "--stdio" } },
                tsserver = { cmd = { "typescript-language-server", "--stdio" } },
                gopls = { cmd = { "gopls" } },
                clangd = { cmd = { "clangd" } },
                bashls = { cmd = { "bash-language-server", "start" } },
                cssls = { cmd = { "vscode-css-language-server", "--stdio" } },
                html = { cmd = { "vscode-html-language-server", "--stdio" } },
                jsonls = { cmd = { "vscode-json-language-server", "--stdio" } },
            }

            local server_config = server_configs[server_name]
            if server_config and vim.fn.executable(server_config.cmd[1]) == 1 then
                for k, v in pairs(server_config) do
                    config[k] = v
                end
                lspconfig[server_name].setup(config)
            end
        end

        local servers = {
            "lua_ls",
            "rust_analyzer",
            "pyright",
            "tsserver",
            "gopls",
            "clangd",
            "bashls",
            "cssls",
            "html",
            "jsonls",
        }

        for _, server in ipairs(servers) do
            setup_server_if_available(server)
        end
    end,
}
