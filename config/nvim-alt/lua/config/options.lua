local opt = vim.opt

-- Line numbers
opt.number = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.wrap = false
opt.cursorline = true

-- Behavior
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.iskeyword:append("-")

-- Completion
opt.completeopt = "menuone,noselect"

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Update time
opt.updatetime = 50
opt.timeoutlen = 300

-- Disable tabs/tabline to simplify UI
opt.showtabline = 0
