-- Check if we are in vscode
-- if vim.g.vscode then
--   return
-- end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("oil").setup({
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
            local m = name:match("^%..$") or name:match("^%.git$") or name:match("^%.DS_Store$")
            return m ~= nil
        end,
    },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
vim.keymap.set("n", "<leader>d", builtin.diagnostics, {})
vim.keymap.set("n", "<leader>f", builtin.find_files, {})
vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
vim.keymap.set("n", "<leader>j", builtin.jumplist, {})
vim.keymap.set("n", "<leader>s", builtin.lsp_document_symbols, {})
vim.keymap.set("n", "<leader>S", builtin.lsp_workspace_symbols, {})

local lspconfig = require("lspconfig")
lspconfig.astro.setup({})
lspconfig.cssls.setup({})
lspconfig.eslint.setup({})
lspconfig.gleam.setup({})
lspconfig.html.setup({})
lspconfig.jsonls.setup({})
lspconfig.lua_ls.setup({})
lspconfig.omnisharp.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.sourcekit.setup({})
lspconfig.tailwindcss.setup({})
lspconfig.zls.setup({})
