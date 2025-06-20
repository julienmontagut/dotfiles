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
                    on_attach = function(client, bufnr)
                        -- Use common LSP functionality
                        _G.common_on_attach(client, bufnr)

                        local opts = { buffer = bufnr, noremap = true, silent = true }
                        -- Rust-specific hover with actions
                        vim.keymap.set("n", "K", rt.hover_actions.hover_actions, opts)
                        -- Code actions and language features (c = code) - rust-specific code actions override LSP
                        vim.keymap.set(
                            "n",
                            "<Leader>ca",
                            rt.code_action_group.code_action_group,
                            vim.tbl_extend("force", opts, { desc = "Rust code actions" })
                        )
                        vim.keymap.set(
                            "n",
                            "<Leader>cr",
                            rt.runnables.runnables,
                            vim.tbl_extend("force", opts, { desc = "Code runnables" })
                        )
                        vim.keymap.set(
                            "n",
                            "<Leader>cd",
                            rt.debuggables.debuggables,
                            vim.tbl_extend("force", opts, { desc = "Code debuggables" })
                        )
                        vim.keymap.set(
                            "n",
                            "<Leader>ce",
                            rt.expand_macro.expand_macro,
                            vim.tbl_extend("force", opts, { desc = "Expand macro" })
                        )
                        vim.keymap.set(
                            "n",
                            "<Leader>ch",
                            rt.inlay_hints.toggle_inlay_hints,
                            vim.tbl_extend("force", opts, { desc = "Toggle hints" })
                        )
                        vim.keymap.set(
                            "n",
                            "<Leader>cg",
                            rt.crate_graph.view_crate_graph,
                            vim.tbl_extend("force", opts, { desc = "View crate graph" })
                        )
                        vim.keymap.set(
                            "n",
                            "<Leader>cm",
                            rt.parent_module.parent_module,
                            vim.tbl_extend("force", opts, { desc = "Parent module" })
                        )
                        -- Enhanced navigation and LSP actions
                        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
                        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
                        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                        vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

                        -- Diagnostic navigation
                        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                        vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float, opts)
                        vim.keymap.set("n", "<Leader>dl", vim.diagnostic.setloclist, opts)

                        -- Workspace management
                        vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, opts)
                        vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
                        vim.keymap.set("n", "<Leader>wl", function()
                            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                        end, opts)

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

            -- Additional Rust-specific keybindings for efficient development
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "rust",
                callback = function(event)
                    local opts = { buffer = event.buf, noremap = true, silent = true }

                    -- Build commands (b = build) - specific build shortcuts
                    vim.keymap.set(
                        "n",
                        "<leader>bb",
                        ":!cargo build<CR>",
                        vim.tbl_extend("force", opts, { desc = "Build" })
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>br",
                        ":!cargo build --release<CR>",
                        vim.tbl_extend("force", opts, { desc = "Build release" })
                    )

                    -- Run commands (r = run) - all other execution, testing, linting
                    vim.keymap.set(
                        "n",
                        "<leader>rc",
                        ":!cargo check<CR>",
                        vim.tbl_extend("force", opts, { desc = "Run check" })
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>rl",
                        ":!cargo clippy<CR>",
                        vim.tbl_extend("force", opts, { desc = "Run lint" })
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>rf",
                        ":!cargo fmt<CR>",
                        vim.tbl_extend("force", opts, { desc = "Run format" })
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>rt",
                        ":!cargo test<CR>",
                        vim.tbl_extend("force", opts, { desc = "Run tests" })
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>rw",
                        ":!cargo watch -x check<CR>",
                        vim.tbl_extend("force", opts, { desc = "Run watch" })
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>rd",
                        ":!cargo doc --open<CR>",
                        vim.tbl_extend("force", opts, { desc = "Run docs" })
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>rx",
                        ":!cargo run --example ",
                        vim.tbl_extend("force", opts, { desc = "Run example" })
                    )
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

            -- Package management (p = package) - moved from crates config
            vim.keymap.set(
                "n",
                "<leader>pt",
                crates.toggle,
                { silent = true, desc = "Toggle package info" }
            )
            vim.keymap.set(
                "n",
                "<leader>pr",
                crates.reload,
                { silent = true, desc = "Reload packages" }
            )
            vim.keymap.set(
                "n",
                "<leader>pv",
                crates.show_versions_popup,
                { silent = true, desc = "Show versions" }
            )
            vim.keymap.set(
                "n",
                "<leader>pf",
                crates.show_features_popup,
                { silent = true, desc = "Show features" }
            )
            vim.keymap.set(
                "n",
                "<leader>pd",
                crates.show_dependencies_popup,
                { silent = true, desc = "Show dependencies" }
            )
            vim.keymap.set(
                "n",
                "<leader>pu",
                crates.update_crate,
                { silent = true, desc = "Update package" }
            )
            vim.keymap.set(
                "v",
                "<leader>pu",
                crates.update_crates,
                { silent = true, desc = "Update selected packages" }
            )
            vim.keymap.set(
                "n",
                "<leader>pa",
                crates.update_all_crates,
                { silent = true, desc = "Update all packages" }
            )
            vim.keymap.set(
                "n",
                "<leader>pU",
                crates.upgrade_crate,
                { silent = true, desc = "Upgrade package" }
            )
            vim.keymap.set(
                "v",
                "<leader>pU",
                crates.upgrade_crates,
                { silent = true, desc = "Upgrade selected packages" }
            )
            vim.keymap.set(
                "n",
                "<leader>pA",
                crates.upgrade_all_crates,
                { silent = true, desc = "Upgrade all packages" }
            )
            vim.keymap.set(
                "n",
                "<leader>ph",
                crates.open_homepage,
                { silent = true, desc = "Open package homepage" }
            )
            vim.keymap.set(
                "n",
                "<leader>po",
                crates.open_repository,
                { silent = true, desc = "Open package repository" }
            )
            vim.keymap.set(
                "n",
                "<leader>pc",
                crates.open_crates_io,
                { silent = true, desc = "Open on crates.io" }
            )
            vim.keymap.set("n", "<leader>pn", ":!cargo new ", { desc = "New package" })
            vim.keymap.set("n", "<leader>pi", ":!cargo install ", { desc = "Install package" })
            vim.keymap.set("n", "<leader>pp", ":!cargo publish<CR>", { desc = "Publish package" })
        end,
    },
}
