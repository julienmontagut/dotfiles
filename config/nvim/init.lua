-- General user interface
vim.opt.number = true
vim.opt.colorcolumn = "80,100"
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- Tabs and indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Behaviour
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.completeopt = "menuone,noselect,popup"

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- Plugins
vim.pack.add {
    "https://github.com/folke/flash.nvim",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/folke/trouble.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-mini/mini.icons",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/seblj/roslyn.nvim",
    "https://github.com/christoomey/vim-tmux-navigator",
}

-- Tmux navigation (seamless Ctrl+W h/j/k/l across neovim splits and tmux panes)
vim.g.tmux_navigator_no_mappings = 1
vim.keymap.set("n", "<C-w>h", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate left (vim/tmux)" })
vim.keymap.set("n", "<C-w>j", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate down (vim/tmux)" })
vim.keymap.set("n", "<C-w>k", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate up (vim/tmux)" })
vim.keymap.set("n", "<C-w>l", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate right (vim/tmux)" })

-- Plugin setup
require("flash").setup{}
require("mini.icons").setup{}
require("trouble").setup{}

-- Oil
require("oil").setup {
    default_file_explorer = true,
    show_hidden = true,
}
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Snacks
require("snacks").setup {
    picker = {
        enabled = true,
        win = {
            input = {
                keys = {
                    ["<c-y>"] = { "confirm", mode = { "i", "n" } },
                },
            },
        },
    },
    indent = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
}

vim.keymap.set("n", "<leader>e", function() Snacks.picker.explorer() end, { desc = "Toggle explorer" })
vim.keymap.set("n", "<leader>sf", function() Snacks.picker.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>sr", function() Snacks.picker.recent() end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sc", function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help pages" })

-- Treesitter: highlighting is native in neovim 0.12.
-- Bundled parsers: c, lua, markdown, vim, vimdoc.
-- Install others with :TSInstall (requires tree-sitter CLI).
local ts_parsers = {
    "c_sharp", "rust", "lua", "bash",
    "swift", "json", "toml", "nickel",
    "html", "css",
}
local ts_installed = require("nvim-treesitter.config").get_installed()
local ts_to_install = vim.iter(ts_parsers)
    :filter(function(p) return not vim.tbl_contains(ts_installed, p) end)
    :totable()
if #ts_to_install > 0 then
    require("nvim-treesitter").install(ts_to_install)
end

-- Treesitter textobjects
require("nvim-treesitter-textobjects").setup {
    select = { lookahead = true },
    move = { set_jumps = true },
}

local ts_select = require("nvim-treesitter-textobjects.select")
local ts_move = require("nvim-treesitter-textobjects.move")
local ts_swap = require("nvim-treesitter-textobjects.swap")

-- Select
for key, query in pairs({
    ["af"] = "@function.outer", ["if"] = "@function.inner",
    ["ac"] = "@class.outer",    ["ic"] = "@class.inner",
    ["aa"] = "@parameter.outer", ["ia"] = "@parameter.inner",
    ["ab"] = "@block.outer",    ["ib"] = "@block.inner",
    ["al"] = "@loop.outer",     ["il"] = "@loop.inner",
}) do
    vim.keymap.set({ "x", "o" }, key, function()
        ts_select.select_textobject(query, "textobjects")
    end)
end

-- Move (next/prev start and end)
for key, query in pairs({
    ["]f"] = "@function.outer", ["]c"] = "@class.outer",
    ["]a"] = "@parameter.inner", ["]b"] = "@block.outer",
}) do
    vim.keymap.set({ "n", "x", "o" }, key, function()
        ts_move.goto_next_start(query, "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, key:upper(), function()
        ts_move.goto_next_end(query, "textobjects")
    end)
    local prev_key = key:gsub("%]", "[")
    vim.keymap.set({ "n", "x", "o" }, prev_key, function()
        ts_move.goto_previous_start(query, "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, prev_key:upper(), function()
        ts_move.goto_previous_end(query, "textobjects")
    end)
end

-- Swap
vim.keymap.set("n", "<leader>]a", function() ts_swap.swap_next("@parameter.inner") end, { desc = "Swap next parameter" })
vim.keymap.set("n", "<leader>[a", function() ts_swap.swap_previous("@parameter.inner") end, { desc = "Swap prev parameter" })

-- LSP Configuration
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
        },
    },
})

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
            cargo = { allFeatures = true },
            procMacro = { enable = true },
        },
    },
})

vim.lsp.enable({
    "lua_ls",
    "rust_analyzer",
    "taplo",
    "bashls",
    "jsonls",
    "html",
    "cssls",
    "sourcekit",
    "nickel_ls",
})

-- Built-in LSP completion
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, {
                autotrigger = true,
            })
        end
    end,
})

-- Roslyn (C#) - uses roslyn.nvim for the latest Roslyn LSP
require("roslyn").setup {
    filewatching = true,
}

-- Project root detection (best match first, git fallback)
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
        -- Skip non-file buffers (including oil.nvim)
        if vim.bo[args.buf].buftype ~= "" then return end

        local root = vim.fs.root(args.buf, function(name)
            return name:match("%.sln$") ~= nil
        end)
        or vim.fs.root(args.buf, { "Cargo.toml" })
        or vim.fs.root(args.buf, { "package.json" })
        or vim.fs.root(args.buf, { "go.mod" })
        or vim.fs.root(args.buf, { "pyproject.toml", "setup.py" })
        or vim.fs.root(args.buf, { ".git" })

        if root then
            vim.fn.chdir(root)
        end
    end,
})
