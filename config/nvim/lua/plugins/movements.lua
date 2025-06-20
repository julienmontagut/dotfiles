return {
    {
        "folke/flash.nvim",
        event = "VeryLazy", -- Load after startup for minimal impact
        opts = {
            -- Default search mode
            search = {
                multi_window = true,
                forward = true,
                wrap = true,
                incremental = false,
            },
            -- Jump mode configuration
            jump = {
                jumplist = true,
                pos = "start",
                history = false,
                register = false,
                nohlsearch = false,
                autojump = false,
            },
            -- Label configuration
            label = {
                uppercase = true,
                exclude = "",
                current = true,
                after = true,
                before = false,
                style = "overlay",
                reuse = "lowercase",
                distance = true,
                min_pattern_length = 0,
                rainbow = {
                    enabled = false,
                    shade = 5,
                },
            },
            -- Highlight configuration
            highlight = {
                backdrop = true,
                matches = true,
                priority = 5000,
                groups = {
                    match = "FlashMatch",
                    current = "FlashCurrent",
                    backdrop = "FlashBackdrop",
                    label = "FlashLabel",
                },
            },
            -- Motion modes
            modes = {
                search = {
                    enabled = true,
                    highlight = { backdrop = false },
                    jump = { history = true, register = true, nohlsearch = true },
                    search = {},
                },
                char = {
                    enabled = true,
                    config = function(opts)
                        opts.autohide = opts.autohide == nil
                            and vim.fn.mode(true):find("no")
                            and vim.v.operator == "y"
                        opts.jump_labels = opts.jump_labels == nil
                            and vim.fn.mode(true):find("no")
                            and vim.v.operator ~= "y"
                    end,
                    autohide = false,
                    jump_labels = false,
                    multi_line = true,
                    label = { exclude = "hjkliardc" },
                    keys = { "f", "F", "t", "T", ";", "," },
                    char_actions = function(motion)
                        return {
                            [";"] = "next",
                            [","] = "prev",
                            [motion:lower()] = "next",
                            [motion:upper()] = "prev",
                        }
                    end,
                    search = { wrap = false },
                    highlight = { backdrop = true },
                    jump = { register = false },
                },
                treesitter = {
                    labels = "abcdefghijklmnopqrstuvwxyz",
                    jump = { pos = "range" },
                    search = { incremental = false },
                    label = { before = true, after = true, style = "inline" },
                    highlight = {
                        backdrop = false,
                        matches = false,
                    },
                },
                treesitter_search = {
                    jump = { pos = "range" },
                    search = { multi_window = true, wrap = true, incremental = false },
                    remote_op = { restore = true },
                    label = { before = false, after = true, style = "inline" },
                },
                remote = {
                    remote_op = { restore = true, motion = true },
                },
            },
            -- Prompt configuration
            prompt = {
                enabled = true,
                prefix = { { "⚡", "FlashPromptIcon" } },
                win_config = {
                    relative = "editor",
                    width = 1,
                    height = 1,
                    row = -1,
                    col = 0,
                    zindex = 1000,
                },
            },
            -- Remote flash for operator pending mode
            remote_op = {
                restore = false,
                motion = false,
            },
        },
        keys = {
            -- Main flash jump - most important key
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash jump",
            },
            -- Treesitter-aware flash
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash treesitter",
            },
            -- Remote flash for operator pending
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote flash",
            },
            -- Treesitter search
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter search",
            },
            -- Toggle flash search in command mode
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle flash search",
            },
        },
        config = function(_, opts)
            require("flash").setup(opts)

            -- Set up highlight groups to work well with your colorscheme
            vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#545c7e" })
            vim.api.nvim_set_hl(0, "FlashMatch", { bg = "#ff007c", fg = "#c8d3f5", bold = true })
            vim.api.nvim_set_hl(0, "FlashCurrent", { bg = "#ff966c", fg = "#1b1d2b", bold = true })
            vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#ff007c", fg = "#c8d3f5", bold = true })
        end,
    },
}
