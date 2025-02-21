return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
        "onsails/lspkind.nvim",
    },
    version = "*",

    opts = {
        enabled = function()
            return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
        end,
        keymap = {
            preset = "super-tab",
            mappings = {
                ["<Tab>"] = {
                    action = function(fallback)
                        if not require("blink.cmp").visible() then
                            fallback()
                            return
                        end
                        require("blink.cmp").accept()
                    end,
                },
            },
        },
        completion = {
            keyword = {
                range = "full", -- Will match text before and after cursor
            },
            trigger = {
                prefetch_on_insert = true,
                show_in_snippet = true,
                show_on_keyword = true,
                show_on_trigger_character = true,
                show_on_blocked_trigger_characters = { " ", "\n", "\t" },
                show_on_accept_on_trigger_character = true,
                show_on_insert_on_trigger_character = true,
            },
            list = {
                max_items = 20, -- Keep list manageable
                selection = {
                    preselect = true,
                    auto_insert = true,
                },
                cycle = {
                    from_bottom = true,
                    from_top = true,
                },
            },
            accept = {
                dot_repeat = true,
                create_undo_point = true,
                resolve_timeout_ms = 100,
                auto_brackets = {
                    enabled = true,
                    kind_resolution = {
                        enabled = true,
                        blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
                    },
                    semantic_token_resolution = {
                        enabled = true,
                        timeout_ms = 400,
                    },
                },
            },
            menu = {
                enabled = true,
                min_width = 25,
                max_height = 15,
                border = "rounded",
                winblend = 0,
                winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                scrolloff = 2,
                scrollbar = true,
                direction_priority = { "s", "n" },
                auto_show = true,
                draw = {
                    align_to = "label",
                    padding = { 1, 1 }, -- Left and right padding
                    gap = 1,
                    columns = {
                        { "kind_icon" },
                        { "label", "label_description", gap = 1 },
                    },
                },
            },
        },

        sources = {
            default = {
                "lsp",
                "snippets",
                "path",
                "buffer",
            },
            per_filetype = {
                lua = { "lsp", "path", "snippets" },
            },
            min_keyword_length = 1,
            providers = {
                lsp = {
                    async = true,
                    timeout_ms = 2000,
                    fallbacks = { "buffer" },
                },
                path = {
                    score_offset = 3,
                    fallbacks = { "buffer" },
                    opts = {
                        trailing_slash = true,
                        label_trailing_slash = true,
                        show_hidden_files_by_default = false,
                    },
                },
                snippets = {
                    opts = {
                        friendly_snippets = true,
                        search_paths = { vim.fn.stdpath("config") .. "/snippets" },
                        global_snippets = { "all" },
                    },
                },
                buffer = {
                    opts = {
                        get_bufnrs = function()
                            return vim.iter(vim.api.nvim_list_wins())
                                :map(function(win)
                                    return vim.api.nvim_win_get_buf(win)
                                end)
                                :filter(function(buf)
                                    return vim.bo[buf].buftype ~= "nofile"
                                end)
                                :totable()
                        end,
                    },
                },
            },
        },

        appearance = {
            highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
            nerd_font_variant = "mono",
        },

        cmdline = {
            enabled = true,
            sources = function()
                local type = vim.fn.getcmdtype()
                if type == "/" or type == "?" then
                    return { "buffer" }
                end
                if type == ":" or type == "@" then
                    return { "cmdline" }
                end
                return {}
            end,
            completion = {
                menu = {
                    draw = {
                        columns = { { "label", "label_description", gap = 1 } },
                    },
                },
            },
        },
    },
}
