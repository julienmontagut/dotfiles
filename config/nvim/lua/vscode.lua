-- VSCode Neovim configuration
-- This file is only loaded when running inside VSCode

local M = {}

-- Helper function to set VSCode Neovim keybindings
local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Common movements and editing commands
-- Navigation
map("n", "j", "gj") -- Better line navigation
map("n", "k", "gk")
map("v", "j", "gj")
map("v", "k", "gk")

-- Quick escape from insert mode is now set in init.lua for all environments

-- Copy, cut, paste with system clipboard
map({"n", "v"}, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({"n", "v"}, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map({"n", "v"}, "<leader>P", '"+P', { desc = "Paste from system clipboard (before)" })

-- Quick save
map("n", "<leader>w", "<Cmd>call VSCodeNotify('workbench.action.files.save')<CR>", { desc = "Save file" })

-- Window navigation
map("n", "<C-h>", "<Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>", { desc = "Navigate left" })
map("n", "<C-j>", "<Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>", { desc = "Navigate down" })
map("n", "<C-k>", "<Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>", { desc = "Navigate up" })
map("n", "<C-l>", "<Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>", { desc = "Navigate right" })

-- Searching
map("n", "<leader>f", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>", { desc = "Find files" })
map("n", "<leader>s", "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>", { desc = "Search in files" })

-- Code actions
map("n", "<leader>ca", "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>", { desc = "Code action" })
map("n", "<leader>cr", "<Cmd>call VSCodeNotify('editor.action.rename')<CR>", { desc = "Rename symbol" })
map("n", "<leader>cf", "<Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>", { desc = "Format document" })

-- Go to definition/references (similar to ideavimrc style)
map("n", "gd", "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>", { desc = "Go to definition" })
map("n", "<leader>gd", "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>", { desc = "Go to definition" })
map("n", "<leader>gy", "<Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>", { desc = "Go to type definition" })
map("n", "<leader>gi", "<Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>", { desc = "Go to implementation" })
map("n", "<leader>gu", "<Cmd>call VSCodeNotify('references-view.findReferences')<CR>", { desc = "Find references" })
map("n", "gr", "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>", { desc = "Go to references" })
map("n", "gh", "<Cmd>call VSCodeNotify('editor.action.showHover')<CR>", { desc = "Show hover" })

-- Navigate back and forth
map("n", "<leader>gb", "<Cmd>call VSCodeNotify('workbench.action.navigateForward')<CR>", { desc = "Navigate forward" })
map("n", "<leader>gf", "<Cmd>call VSCodeNotify('workbench.action.navigateBack')<CR>", { desc = "Navigate back" })

-- Jump between methods
map("n", "[[", "<Cmd>call VSCodeNotify('editor.action.gotoPreviousSymbol')<CR>", { desc = "Previous method" })
map("n", "]]", "<Cmd>call VSCodeNotify('editor.action.gotoNextSymbol')<CR>", { desc = "Next method" })

-- Tabs/Buffers
map("n", "<leader>bn", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>", { desc = "Next editor" })
map("n", "<leader>bp", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>", { desc = "Previous editor" })
map("n", "<leader>bc", "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", { desc = "Close editor" })

-- Explorer
map("n", "<leader>e", "<Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>", { desc = "Toggle explorer" })

-- Comments
map("n", "gc", "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>", { desc = "Comment line" })
map("v", "gc", "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>", { desc = "Comment selection" })

-- Debugging
map("n", "<leader>rd", "<Cmd>call VSCodeNotify('workbench.action.debug.start')<CR>", { desc = "Start debugging" })
map("n", "<leader>rb", "<Cmd>call VSCodeNotify('editor.debug.action.toggleBreakpoint')<CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>rc", "<Cmd>call VSCodeNotify('workbench.action.debug.continue')<CR>", { desc = "Continue debugging" })
map("n", "<leader>rs", "<Cmd>call VSCodeNotify('workbench.action.debug.stepOver')<CR>", { desc = "Step over" })
map("n", "<leader>ri", "<Cmd>call VSCodeNotify('workbench.action.debug.stepInto')<CR>", { desc = "Step into" })
map("n", "<leader>ro", "<Cmd>call VSCodeNotify('workbench.action.debug.stepOut')<CR>", { desc = "Step out" })

-- Text formatting
map("n", "Q", "gq", { desc = "Format text" })

-- Additional settings specific to VSCode
vim.opt.clipboard = "unnamed,unnamedplus" -- Use system clipboard by default
vim.opt.scrolloff = 5 -- Keep 5 lines visible around cursor
vim.opt.sidescrolloff = 10 -- Keep 10 columns visible around cursor

return M
