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
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste from system clipboard (before)" })

-- Quick save
map("n", "<leader>w", function()
    vim.fn.VSCodeCall("workbench.action.files.save")
end, { desc = "Save file" })

-- Window navigation
map("n", "<C-h>", function()
    vim.fn.VSCodeCall("workbench.action.navigateLeft")
end, { desc = "Navigate left" })
map("n", "<C-j>", function()
    vim.fn.VSCodeCall("workbench.action.navigateDown")
end, { desc = "Navigate down" })
map("n", "<C-k>", function()
    vim.fn.VSCodeCall("workbench.action.navigateUp")
end, { desc = "Navigate up" })
map("n", "<C-l>", function()
    vim.fn.VSCodeCall("workbench.action.navigateRight")
end, { desc = "Navigate right" })

-- Searching
map("n", "<leader>f", function()
    vim.fn.VSCodeCall("workbench.action.quickOpen")
end, { desc = "Find files" })
map("n", "<leader>s", function()
    vim.fn.VSCodeCall("workbench.action.findInFiles")
end, { desc = "Search in files" })

-- Code actions
map("n", "<leader>ca", function()
    vim.fn.VSCodeCall("editor.action.quickFix")
end, { desc = "Code action" })
map("n", "<leader>cr", function()
    vim.fn.VSCodeCall("editor.action.rename")
end, { desc = "Rename symbol" })
map("n", "<leader>cf", function()
    vim.fn.VSCodeCall("editor.action.formatDocument")
end, { desc = "Format document" })

-- Go to definition/references (similar to ideavimrc style)
map("n", "gd", function()
    vim.fn.VSCodeCall("editor.action.revealDefinition")
end, { desc = "Go to definition" })
map("n", "<leader>gd", function()
    vim.fn.VSCodeCall("editor.action.revealDefinition")
end, { desc = "Go to definition" })
map("n", "<leader>gy", function()
    vim.fn.VSCodeCall("editor.action.goToTypeDefinition")
end, { desc = "Go to type definition" })
map("n", "<leader>gi", function()
    vim.fn.VSCodeCall("editor.action.goToImplementation")
end, { desc = "Go to implementation" })
map("n", "<leader>gu", function()
    vim.fn.VSCodeCall("references-view.findReferences")
end, { desc = "Find references" })
map("n", "gr", function()
    vim.fn.VSCodeCall("editor.action.goToReferences")
end, { desc = "Go to references" })
map("n", "gh", function()
    vim.fn.VSCodeCall("editor.action.showHover")
end, { desc = "Show hover" })

-- Navigate back and forth
map("n", "<leader>gb", function()
    vim.fn.VSCodeCall("workbench.action.navigateForward")
end, { desc = "Navigate forward" })
map("n", "<leader>gf", function()
    vim.fn.VSCodeCall("workbench.action.navigateBack")
end, { desc = "Navigate back" })

-- Jump between methods
map("n", "[[", function()
    vim.fn.VSCodeCall("editor.action.gotoPreviousSymbol")
end, { desc = "Previous method" })
map("n", "]]", function()
    vim.fn.VSCodeCall("editor.action.gotoNextSymbol")
end, { desc = "Next method" })

-- Tabs/Buffers
map("n", "<leader>bn", function()
    vim.fn.VSCodeCall("workbench.action.nextEditor")
end, { desc = "Next editor" })
map("n", "<leader>bp", function()
    vim.fn.VSCodeCall("workbench.action.previousEditor")
end, { desc = "Previous editor" })
map("n", "<leader>bc", function()
    vim.fn.VSCodeCall("workbench.action.closeActiveEditor")
end, { desc = "Close editor" })

-- Explorer
map("n", "<leader>e", function()
    vim.fn.VSCodeCall("workbench.action.toggleSidebarVisibility")
end, { desc = "Toggle explorer" })

-- Comments
map("n", "gc", function()
    vim.fn.VSCodeCall("editor.action.commentLine")
end, { desc = "Comment line" })
map("v", "gc", function()
    vim.fn.VSCodeCall("editor.action.commentLine")
end, { desc = "Comment selection" })

-- Debugging
map("n", "<leader>rd", function()
    vim.fn.VSCodeCall("workbench.action.debug.start")
end, { desc = "Start debugging" })
map("n", "<leader>rb", function()
    vim.fn.VSCodeCall("editor.debug.action.toggleBreakpoint")
end, { desc = "Toggle breakpoint" })
map("n", "<leader>rc", function()
    vim.fn.VSCodeCall("workbench.action.debug.continue")
end, { desc = "Continue debugging" })
map("n", "<leader>rs", function()
    vim.fn.VSCodeCall("workbench.action.debug.stepOver")
end, { desc = "Step over" })
map("n", "<leader>ri", function()
    vim.fn.VSCodeCall("workbench.action.debug.stepInto")
end, { desc = "Step into" })
map("n", "<leader>ro", function()
    vim.fn.VSCodeCall("workbench.action.debug.stepOut")
end, { desc = "Step out" })

-- Text formatting
map("n", "Q", "gq", { desc = "Format text" })

-- Additional settings specific to VSCode
vim.opt.clipboard = "unnamed,unnamedplus" -- Use system clipboard by default
vim.opt.scrolloff = 5 -- Keep 5 lines visible around cursor
vim.opt.sidescrolloff = 10 -- Keep 10 columns visible around cursor

return M
