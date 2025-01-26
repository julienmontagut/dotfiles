-- Check if we are in vscode
-- if vim.g.vscode then
--   return
-- end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Setup mini modules
require("mini.ai").setup()
-- require('mini.base16').setup()
require("mini.basics").setup {
    options = {
        basics = true,
        extra_ui = true,
    },
    mappings = {
        basic = false,
    },
    autocommands = {
        basics = true,
        relnum_in_visual_mode = false,
    },
}
require("mini.bracketed").setup()
local miniclue = require "mini.clue"
miniclue.setup {
    window = {
        delay = 500,
    },
    triggers = {
        -- Leader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },

        -- Marks
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },

        -- Registers
        { mode = "n", keys = "\"" },
        { mode = "x", keys = "\"" },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },

        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
    },

    clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
    },
}
require("mini.diff").setup()
-- require('mini.comment').setup()
require("mini.completion").setup()
-- require('mini.files').setup()
require("mini.hipatterns").setup {
    highlighters = {
        -- Highlight 'FIXME', 'TODO', 'NOTE'
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    },
}
require("mini.icons").setup()
local minijump = require "mini.jump2d"
local minijump_spotter = minijump.builtin_opts.word_start
minijump.setup {
    spotter = minijump_spotter.spotter,
    view = {
        dim = false,
        n_steps_ahead = 3,
    },
    mappings = {
        start_jumping = "gw",
    },
}
require("mini.notify").setup()
require("mini.pairs").setup()
require("mini.sessions").setup {
    -- autoread = true,
    autowrite = true,
}

require("mini.statusline").setup()
require("mini.surround").setup()
require("mini.tabline").setup()

require("oil").setup {
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
            local m = name:match "^%..$" or name:match "^%.git$" or name:match "^%.DS_Store$"
            return m ~= nil
        end,
    },
}

local builtin = require "telescope.builtin"
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
vim.keymap.set("n", "<leader>d", builtin.diagnostics, {})
vim.keymap.set("n", "<leader>f", builtin.find_files, {})
vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
vim.keymap.set("n", "<leader>j", builtin.jumplist, {})
vim.keymap.set("n", "<leader>s", builtin.lsp_document_symbols, {})
vim.keymap.set("n", "<leader>S", builtin.lsp_workspace_symbols, {})

local lspconfig = require "lspconfig"
lspconfig.astro.setup {}
lspconfig.cssls.setup {}
lspconfig.eslint.setup {}
lspconfig.gleam.setup {}
lspconfig.html.setup {}
lspconfig.jsonls.setup {}
lspconfig.lua_ls.setup {}
lspconfig.nil_ls.setup {}
lspconfig.omnisharp.setup {}
lspconfig.rust_analyzer.setup {}
lspconfig.sourcekit.setup {}
lspconfig.tailwindcss.setup {}
lspconfig.zls.setup {}
