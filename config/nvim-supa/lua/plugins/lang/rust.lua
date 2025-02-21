return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                rust_analyzer = {
                    -- Basic settings to ensure it's registered
                    filetypes = { "rust" },
                    root_dir = require("lspconfig.util").root_pattern(
                        "Cargo.toml",
                        "rust-project.json"
                    ),
                },
                taplo = {
                    settings = {
                        -- Enable completions from workspace dependencies
                        enable_workspace_support = true,
                        -- Enable completions from remote registries
                        enable_remote_registry_support = true,
                    },
                },
            },
            setup = {
                rust_analyzer = function()
                    return true
                end,
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { "rust", "toml" })
        end,
    },
    {
        "simrat39/rust-tools.nvim",
        ft = "rust",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local rt = require("rust-tools")

            -- Setup rust-tools first
            rt.setup({
                tools = {
                    hover_actions = {
                        auto_focus = true,
                    },
                    inlay_hints = {
                        auto = true,
                        show_parameter_hints = true,
                        parameter_hints_prefix = "<- ",
                        other_hints_prefix = "=> ",
                    },
                },
                server = {
                    standalone = true, -- This ensures rust-analyzer starts independently
                    on_attach = function(client, bufnr)
                        -- Ensure LSP is fully functional
                        local opts = { buffer = bufnr, noremap = true, silent = true }
                        -- Add your keymaps here
                        vim.keymap.set("n", "K", rt.hover_actions.hover_actions, opts)
                        vim.keymap.set(
                            "n",
                            "<Leader>a",
                            rt.code_action_group.code_action_group,
                            opts
                        )
                        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)

                        -- Enable inlay hints by default
                        if client.server_capabilities.inlayHintProvider then
                            vim.lsp.inlay_hint.enable(bufnr, true)
                        end

                        -- Print notification when rust-analyzer attaches
                        vim.notify("rust-analyzer started", vim.log.levels.INFO)
                    end,
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                            },
                            completion = {
                                autoimport = {
                                    enable = true,
                                },
                                autoself = {
                                    enable = true,
                                },
                                callable = {
                                    snippets = "fill_arguments",
                                },
                                fullFunctionSignatures = {
                                    enable = true,
                                },
                                limit = 100,
                                postfix = {
                                    enable = true,
                                },
                                privateEditable = {
                                    enable = true,
                                },
                                snippets = {
                                    custom = {
                                        ["Arc::new"] = {
                                            postfix = "arc",
                                            body = "Arc::new(${receiver})",
                                            requires = "std::sync::Arc",
                                            description = "Put the expression into an Arc",
                                            scope = "expr",
                                        },
                                        ["Rc::new"] = {
                                            postfix = "rc",
                                            body = "Rc::new(${receiver})",
                                            requires = "std::rc::Rc",
                                            description = "Put the expression into an Rc",
                                            scope = "expr",
                                        },
                                    },
                                },
                            },
                            hover = {
                                actions = {
                                    enable = true,
                                    debug = true,
                                    gotoTypeDef = true,
                                    implementations = true,
                                    run = true,
                                },
                                documentation = {
                                    enable = true,
                                    keywords = true,
                                },
                            },
                            imports = {
                                granularity = {
                                    group = "module",
                                },
                                prefix = "self",
                                enforce = true,
                            },
                            inlayHints = {
                                bindingModeHints = { enable = true },
                                chainingHints = { enable = true },
                                closingBraceHints = { enable = true, minLines = 25 },
                                closureReturnTypeHints = { enable = "always" },
                                lifetimeElisionHints = {
                                    enable = "always",
                                    useParameterNames = true,
                                },
                                maxLength = 25,
                                parameterHints = { enable = true },
                                reborrowHints = { enable = "always" },
                                renderColons = true,
                                typeHints = {
                                    enable = true,
                                    hideClosureInitialization = false,
                                    hideNamedConstructor = false,
                                },
                            },
                            assist = {
                                importEnforceGranularity = true,
                                importPrefix = "create",
                                expressionFillDefault = "todo",
                            },
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                runBuildScripts = true,
                                buildScripts = {
                                    enable = true,
                                },
                            },
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ["async-trait"] = { "async_trait" },
                                    ["napi-derive"] = { "napi" },
                                    ["async-recursion"] = { "async_recursion" },
                                },
                            },
                            lens = {
                                enable = true,
                                debug = true,
                                implementations = true,
                                run = true,
                                methodReferences = true,
                                references = true,
                            },
                        },
                    },
                },
            })

            -- Add autocommand to check rust-analyzer status
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "rust",
                callback = function()
                    local clients = vim.lsp.get_active_clients()
                    local has_rust_analyzer = false
                    for _, client in ipairs(clients) do
                        if client.name == "rust_analyzer" then
                            has_rust_analyzer = true
                            break
                        end
                    end
                    if not has_rust_analyzer then
                        vim.notify(
                            "rust-analyzer not started. Attempting to start...",
                            vim.log.levels.WARN
                        )
                        -- Try to restart rust-analyzer
                        rt.setup({})
                    end
                end,
            })
        end,
    },
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
            null_ls = {
                enabled = true,
                name = "crates.nvim",
            },
            popup = {
                border = "rounded",
            },
        },
        config = function(_, opts)
            local crates = require("crates")
            crates.setup(opts)

            vim.keymap.set("n", "<leader>ct", crates.toggle, { silent = true })
            vim.keymap.set("n", "<leader>cr", crates.reload, { silent = true })
        end,
    },
}
