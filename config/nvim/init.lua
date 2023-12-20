-- require('plugins')
require('settings')

-- Install lazy.nvim for plugin managemet
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins using lazy 
require("lazy").setup({
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lua",
    
    "christoomey/vim-tmux-navigator",
    "tiagovla/scope.nvim",
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 
            'nvim-lua/plenary.nvim'
        }
    },
    'nvim-lualine/lualine.nvim',
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        priority = 1000
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    }
},{})

-- Configure mason lsp
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
	    "rust_analyzer"
    }
})

require('catppuccin').setup({
    flavour = 'macchiato',
    term_colors = true,
    dim_inactive = {
        enabled = true,
        shade = 'dark',
        percentage = 0.2,
    }
})

require("scope").setup({})

require("telescope").setup({
    extensions = {
        "scope"
    }
})

require('lualine').setup({
    options = {
        theme = 'catppuccin',
        icons_enabled = false,
    }
})

vim.cmd.colorscheme 'catppuccin'

