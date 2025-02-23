return {
    -- Which-key for better command hints
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gz"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>w"] = { name = "+windows" },
            },
        },
    },

    -- Enhanced UI notifications and cmdline
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            notify = {
                enabled = false,
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                hover = { enabled = true },
                signature = { enabled = true },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
                lsp_doc_border = true,
            },
            views = {
                cmdline_popup = {
                    position = { row = 5, col = "50%" },
                    size = { width = 60, height = "auto" },
                    border = { style = "rounded", padding = { 0, 1 } },
                },
                popupmenu = {
                    relative = "editor",
                    position = { row = 8, col = "50%" },
                    size = { width = 60, height = 10 },
                    border = { style = "rounded", padding = { 0, 1 } },
                    win_options = {
                        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                    },
                },
            },
        },
    },

    -- UI Enhancements
    -- {
    --     "folke/snacks.nvim",
    --     lazy = false,
    --     opts = {
    --         dashboard = {
    --             enabled = true,
    --         },
    --         indent = { enabled = true },
    --         input = { enabled = true },
    --         lazygit = { enabled = true },
    --         notifier = {
    --             enabled = true,
    --             timeout = 3000,
    --             max_width = function()
    --                 return math.floor(vim.o.columns * 0.75)
    --             end,
    --             max_height = function()
    --                 return math.floor(vim.o.lines * 0.75)
    --             end,
    --             stages = "fade_in_slide_out",
    --         },
    --         picker = { enabled = true },
    --         quickfile = { enabled = true },
    --         statuscolumn = { enabled = true },
    --         styles = { enabled = true },
    --         toggle = { which_key = true },
    --         words = {},
    --     },
    --     keys = {
    --         {
    --             "<leader>0",
    --             function()
    --                 require("snacks").scratch()
    --             end,
    --             desc = "Toggle scratch buffer",
    --         },
    --     },
    -- },
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        opts = {
            theme = "hyper",
            config = {
                header = {
                    "                                   ",
                    "                                   ",
                    "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣭⣿⣶⣿⣦⣼⣆         ",
                    "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
                    "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷⠄⠄⠄⠄⠻⠿⢿⣿⣧⣄     ",
                    "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
                    "          ⢠⣿⣿⣿⠈  ⠡⠌⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
                    "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘⠄ ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
                    "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
                    " ⣠⣿⠿⠛⠄⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
                    " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇⠄⠛⠻⢷⣄ ",
                    "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
                    "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
                    "                                   ",
                },
                week_header = {
                    enable = true,
                },
                shortcut = {
                    {
                        desc = "󰊳 Update",
                        group = "@property",
                        action = "Lazy update",
                        key = "u",
                    },
                    {
                        icon = " ",
                        icon_hl = "@variable",
                        desc = "Files",
                        group = "Label",
                        action = "Telescope find_files",
                        key = "f",
                    },
                    {
                        desc = " Projects",
                        group = "DiagnosticHint",
                        action = "Telescope projects",
                        key = "p",
                    },
                    {
                        desc = " dotfiles",
                        group = "Number",
                        action = "Telescope find_files cwd=~/.config/supavim",
                        key = "d",
                    },
                },
                packages = { enable = true },
                project = {
                    limit = 8,
                    icon = "󰏓 ",
                    label = "",
                    action = "Telescope find_files cwd=",
                },
                mru = { limit = 10, icon = "󰋚 ", label = "", cwd_only = false },
                footer = function()
                    local stats = require("lazy").stats()
                    return {
                        "⚡ Neovim loaded "
                            .. stats.count
                            .. " plugins in "
                            .. stats.startuptime
                            .. "ms",
                    }
                end,
            },
        },
        config = function(_, opts)
            require("dashboard").setup(opts)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "dashboard",
                callback = function()
                    vim.opt.laststatus = 0
                    vim.opt.showtabline = 0
                    vim.cmd("Neotree close")
                end,
            })
        end,
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
    },

    -- File explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        lazy = false,
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            window = {
                width = 30,
                mappings = {
                    ["<space>"] = "none",
                },
            },
            filesystem = {
                filtered_items = {
                    visible = false,
                    hide_dotfiles = true,
                    hide_gitignored = true,
                    hide_by_name = {
                        ".git",
                        "node_modules",
                        "target",
                    },
                },
                follow_current_file = {
                    enable = true,
                },
                use_libuv_file_watcher = true,
            },
        },
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
        },
    },

    -- Fuzzy finder configuration
    {
        "ibhagwan/fzf-lua",
        dependencies = { "echasnovski/mini.icons" },
        opts = {
            keymap = {
                select = "<C-s>",
            },
            winopts = {
                height = 0.85,
                width = 0.80,
                row = 0.35,
                col = 0.50,
                border = "rounded",
                preview = {
                    border = "border",
                    wrap = "nowrap",
                    hidden = "nohidden",
                    vertical = "down:45%",
                    horizontal = "right:60%",
                    layout = "flex",
                    flip_columns = 120,
                },
            },
        },
    },

    -- Icons configuration
    {
        "echasnovski/mini.icons",
        event = "VeryLazy",
        version = false,
        opts = {},
        specs = {
            { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
}
