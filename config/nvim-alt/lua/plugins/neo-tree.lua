return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "echasnovski/mini.icons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "<leader>ee", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
        { "<leader>ef", "<cmd>Neotree reveal<cr>", desc = "Reveal current file in explorer" },
        { "<leader>eg", "<cmd>Neotree git_status<cr>", desc = "Git status in explorer" },
        { "<leader>eb", "<cmd>Neotree buffers<cr>", desc = "Buffer explorer" },
    },
    deactivate = function()
        vim.cmd([[Neotree close]])
    end,
    init = function()
        if vim.fn.argc(-1) == 1 then
            local stat = vim.loop.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
                require("neo-tree")
            end
        end
    end,
    opts = {
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
        filesystem = {
            bind_to_cwd = false,
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
            filtered_items = {
                visible = false,
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_hidden = true,
                hide_by_name = {
                    ".DS_Store",
                    "thumbs.db",
                },
                never_show = {
                    ".git",
                    ".DS_Store",
                    "thumbs.db",
                },
            },
        },
        window = {
            mappings = {
                ["<space>"] = "none",
                ["Y"] = {
                    function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.fn.setreg("+", path, "c")
                    end,
                    desc = "Copy Path to Clipboard",
                },
                ["O"] = {
                    function(state)
                        require("lazy.util").open(state.tree:get_node().path, { system = true })
                    end,
                    desc = "Open with System Application",
                },
            },
        },
        default_component_configs = {
            indent = {
                with_expanders = true,
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
        },
    },
    config = function(_, opts)
        require("neo-tree").setup(opts)
        vim.api.nvim_create_autocmd("TermClose", {
            pattern = "*lazygit",
            callback = function()
                if package.loaded["neo-tree.sources.git_status"] then
                    require("neo-tree.sources.git_status").refresh()
                end
            end,
        })
    end,
}
