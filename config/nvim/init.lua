-- Leader
vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- General user interface
vim.opt.number = true
vim.opt.colorcolumn = "100"
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.wrap = false

-- Diagnostics ship as signs and underlines only. virtual_lines on the cursor line puts the
-- whole message where the error is, without shoving every other line around all day.
vim.diagnostic.config({
    virtual_lines = { current_line = true },
    severity_sort = true,
})

-- Borders on hover, signature help and diagnostic floats, so a message reads as a message.
vim.opt.winborder = "rounded"
-- "wait" swaps the hit-enter prompt for a timed message window, so a long LSP or build line
-- no longer eats the next keystroke. history keeps them all reachable from :messages.
vim.opt.messagesopt = { "wait:1500", "history:1000" }

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
vim.opt.autocomplete = true
-- Above my typing speed, so the menu appears on a pause instead of mid-word.
vim.opt.autocompletedelay = 150
-- "menu"/"menuone"/"noselect" are inert under 'autocomplete' itself, but the LSP's async
-- vim.fn.complete() path is a plain builtin completion that still obeys them: without
-- them it inserts the first match outright (:h compl-states) and "popup" goes dead.
vim.opt.completeopt = { "menu", "menuone", "noselect", "fuzzy", "popup" }
-- Source order is a time-slice priority under 'autocomplete's decaying timeout, so the
-- LSP ('omnifunc', set per-buffer by nvim) goes first. "^5" caps each buffer scanner so
-- keyword noise cannot drown the LSP items. Dropped "u" (unloaded bufs) and "t" (tags).
vim.opt.complete = { "o", ".^5", "w^5", "b^5" }

-- Disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- Plugins
vim.pack.add({
    "https://github.com/folke/flash.nvim",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/kylechui/nvim-surround",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
    "https://github.com/seblj/roslyn.nvim",
    "https://github.com/stevearc/oil.nvim",
})

-- Plugin setup
require("mini.icons").setup{}
require("mini.diff").setup{}
-- mini.diff signs use MiniDiffSign*; borrow the theme's git palette.
vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { link = "GitSignsAdd" })
vim.api.nvim_set_hl(0, "MiniDiffSignChange", { link = "GitSignsChange" })
vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { link = "GitSignsDelete" })
require("flash").setup{}
require("which-key").setup{}

-- Oil file explorer
require("oil").setup({
    default_file_explorer = true,
    view_options = {
        show_hidden = false,
        is_hidden_file = function(name, bufnr)
            if name == ".git" then
                return true
            end
            local dir = require("oil").get_current_dir(bufnr)
            vim.fn.system({ "git", "-C", dir, "check-ignore", "-q", "--", name })
            return vim.v.shell_error == 0 -- exit 0 = ignored = hidden
        end,
    },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Snacks
require("snacks").setup({
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
})

-- Unified leader scheme (letters match Zed + IdeaVim)
vim.keymap.set("n", "<leader><space>", function()
    Snacks.picker.smart()
end, { desc = "Smart find" })
vim.keymap.set("n", "<leader>f", function()
    Snacks.picker.files()
end, { desc = "Files" })
vim.keymap.set("n", "<leader>g", function()
    Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set("n", "<leader>b", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>e", function()
    Snacks.explorer()
end, { desc = "Explorer" })
vim.keymap.set("n", "<leader>s", function()
    Snacks.picker.lsp_workspace_symbols()
end, { desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>v", function()
    Snacks.picker.git_status()
end, { desc = "Git status" })
vim.keymap.set("n", "<leader>o", function()
    require("mini.diff").toggle_overlay(0)
end, { desc = "Toggle git diff overlay" })
vim.keymap.set("n", "<leader>t", function()
    Snacks.terminal.toggle()
end, { desc = "Terminal" })
vim.keymap.set("n", "<leader>d", function()
    Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>q", function()
    -- getqflist({ winid = 0 }).winid is 0 when the quickfix window is closed. ]q and [q walk
    -- the entries without it: those are 0.11 default mappings.
    vim.cmd(vim.fn.getqflist({ winid = 0 }).winid == 0 and "botright copen" or "cclose")
end, { desc = "Quickfix list" })
vim.keymap.set("n", "<leader>l", vim.lsp.codelens.run, { desc = "Run code lens" })
vim.keymap.set("n", "<leader>n", function()
    Snacks.notifier.show_history()
end, { desc = "Message history" })
vim.keymap.set("n", "<leader>a", function()
    Snacks.git.blame_line()
end, { desc = "Annotate line (git blame)" })
-- Inlay hints are noise while writing and context while reading, so they stay a toggle.
Snacks.toggle.inlay_hints():map("<leader>i")

-- LSP navigation Neovim lacks natively.
-- 0.12 defaults cover gra/gri/grn/grr/grt/grx/gO/K/<C-s>/]d/[d/<C-w>d.
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gS", vim.lsp.buf.workspace_symbol, { desc = "Workspace symbols" })

-- 'autocomplete' + "o" in 'complete' drive the menu. This earns its place by making
-- <C-y> apply snippet expansion, additionalTextEdits (auto-imports) and commands, and by
-- serving the "popup" doc preview. No autotrigger: it is a second engine, and
-- vim.lsp.completion.trigger() bails out whenever a popup is already open, so the two
-- suppress each other.
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf)
        end
        -- Code lenses (run/debug/reference annotations) are pulled, not pushed, so they need
        -- a refresh on attach and after every edit that can move or invalidate one.
        if client and client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.refresh({ bufnr = args.buf })
            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                buffer = args.buf,
                callback = function()
                    vim.lsp.codelens.refresh({ bufnr = args.buf })
                end,
            })
        end
    end,
})

-- Bridge <C-w>hjkl out of terminal-mode
for _, k in ipairs({ "h", "j", "k", "l" }) do
    vim.keymap.set("t", "<C-w>" .. k, [[<C-\><C-n><C-w>]] .. k)
end

-- Treesitter: 0.12 only auto-starts highlighting for markdown/lua/help/query, and
-- nvim-treesitter (main) never starts it at all, so the FileType autocmd below
-- does it for every filetype that has a parser.
-- Bundled parsers: c, lua, markdown, vim, vimdoc.
-- Install others with :TSInstall (requires tree-sitter CLI).
local ts_parsers = {
    "c_sharp",
    "rust",
    "zig",
    "lua",
    "bash",
    "swift",
    "json",
    "toml",
    "nickel",
    "html",
    "css",
}
local ts_installed = require("nvim-treesitter.config").get_installed()
local ts_to_install = vim.iter(ts_parsers)
    :filter(function(p)
        return not vim.tbl_contains(ts_installed, p)
    end)
    :totable()
if #ts_to_install > 0 then
    require("nvim-treesitter").install(ts_to_install)
end

-- pcall: vim.treesitter.start errors for filetypes with no installed parser.
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- Treesitter textobjects
require("nvim-treesitter-textobjects").setup({
    select = { lookahead = true },
    move = { set_jumps = true },
})

local ts_move = require("nvim-treesitter-textobjects.move")
local ts_select = require("nvim-treesitter-textobjects.select")
local ts_swap = require("nvim-treesitter-textobjects.swap")

-- Select
for key, query in pairs({
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    ["aa"] = "@parameter.outer",
    ["ia"] = "@parameter.inner",
    ["ab"] = "@block.outer",
    ["ib"] = "@block.inner",
    ["al"] = "@loop.outer",
    ["il"] = "@loop.inner",
}) do
    vim.keymap.set({ "x", "o" }, key, function()
        ts_select.select_textobject(query, "textobjects")
    end)
end

-- Move (next/prev start and end)
for key, query in pairs({
    ["]f"] = "@function.outer",
    ["]c"] = "@class.outer",
    ["]a"] = "@parameter.inner",
    ["]b"] = "@block.outer",
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
vim.keymap.set("n", "<leader>]a", function()
    ts_swap.swap_next("@parameter.inner")
end, { desc = "Swap next parameter" })
vim.keymap.set("n", "<leader>[a", function()
    ts_swap.swap_previous("@parameter.inner")
end, { desc = "Swap prev parameter" })

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
            check = { command = "clippy" },
            cargo = { allFeatures = true },
        },
    },
})

-- Servers start lazily, on filetype or root marker match, so a missing binary costs
-- one error on the first matching buffer rather than anything at startup.
vim.lsp.enable({
    "lua_ls",
    -- "roslyn_ls",
    "rust_analyzer",
    "sourcekit",
    "taplo",
    "zls",
})

-- Build errors in the quickfix list. :compiler sets 'makeprg' and 'errorformat' per buffer
-- and Nvim ships the plugins for these; :make then parses the build output into quickfix.
-- :make runs the build synchronously though, so the same 'makeprg' goes through vim.system
-- and the output back through the same 'errorformat' instead of freezing the UI for it.
vim.g.cargo_makeprg_params = "build"
local compilers = { cs = "dotnet", rust = "cargo", zig = "zig_build", sh = "bash" }
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local compiler = compilers[vim.bo[args.buf].filetype]
        if compiler then
            vim.cmd.compiler(compiler)
        end
    end,
})

-- ponytail: no in-flight guard, hitting it twice runs two builds.
vim.keymap.set("n", "<leader>m", function()
    -- "$*" is where :make would drop its arguments; there are none here.
    local cmd = vim.trim(vim.fn.expandcmd((vim.o.makeprg:gsub("%$%*", ""))))
    local efm = vim.o.errorformat
    vim.notify(cmd)
    vim.system(vim.split(cmd, "%s+"), { text = true }, function(out)
        vim.schedule(function()
            local lines = vim.split((out.stdout or "") .. (out.stderr or ""), "\n")
            vim.fn.setqflist({}, " ", { title = cmd, lines = lines, efm = efm })
            if vim.tbl_isempty(vim.fn.getqflist()) then
                vim.notify(("%s: clean"):format(cmd))
            else
                vim.cmd("botright copen")
            end
        end)
    end)
end, { desc = "Build" })

-- Project root detection (best match first, git fallback)
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
        -- Skip non-file buffers (including oil.nvim)
        if vim.bo[args.buf].buftype ~= "" then
            -- 'autocomplete' is global-local, so every prompt buffer inherits it: the picker
            -- and Snacks.input get a keyword menu over the query, and while that menu is up
            -- typing fires TextChangedP instead of the TextChangedI they filter on.
            vim.bo[args.buf].autocomplete = false
            return
        end

        local root = vim.fs.root(args.buf, function(name)
            return name:match("%.sln$") ~= nil
        end) or vim.fs.root(args.buf, { "Cargo.toml" }) or vim.fs.root(
            args.buf,
            { "package.json" }
        ) or vim.fs.root(args.buf, { "go.mod" }) or vim.fs.root(
            args.buf,
            { "pyproject.toml", "setup.py" }
        ) or vim.fs.root(args.buf, { ".git" })

        if root then
            vim.fn.chdir(root)
        end
    end,
})

-- rose-pine's default "auto" variant follows 'background': main when dark, dawn when light.
-- Nvim sets 'background' itself from the terminal's OSC 11 reply, so the variant tracks the OS
-- appearance with no help from us. Detection failure falls back to dark, which is what we want.
vim.cmd[[colorscheme rose-pine]]
-- vim.cmd[[colorscheme basalt]]
